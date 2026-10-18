-- Reuse the glab login so no token has to live in the dotfiles.
local function gitlab_token()
  if vim.env.GITLAB_TOKEN and vim.env.GITLAB_TOKEN ~= '' then
    return vim.env.GITLAB_TOKEN
  end
  local out = vim.fn.system({ 'glab', 'config', 'get', 'token', '--host', 'gitlab.com' })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

-- Azure DevOps auth: an Entra access token from the `az` login instead of a PAT (global
-- PATs retire on 2026-12-01). Azure DevOps accepts it in the Basic header Atlas sends.
-- $AZURE_DEVOPS_TOKEN still overrides. The token lives ~1h, see refresh_azure_token().
local AZURE_DEVOPS_RESOURCE = '499b84ac-1321-427f-aa17-267ca6975798'
local AZ_TOKEN_CMD = {
  'az', 'account', 'get-access-token',
  '--resource', AZURE_DEVOPS_RESOURCE,
  '--query', 'accessToken', '-o', 'tsv',
}

local function azure_token()
  if vim.env.AZURE_DEVOPS_TOKEN and vim.env.AZURE_DEVOPS_TOKEN ~= '' then
    return vim.env.AZURE_DEVOPS_TOKEN
  end
  local out = vim.fn.system(AZ_TOKEN_CMD)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

-- Atlas reads `providers.azure.token` on every request, so swapping it in place keeps
-- the `az` token fresh. `az` serves it from cache and only renews near expiry.
local function refresh_azure_token()
  if vim.env.AZURE_DEVOPS_TOKEN and vim.env.AZURE_DEVOPS_TOKEN ~= '' then
    return
  end
  local timer = vim.uv.new_timer()
  timer:start(30 * 60 * 1000, 30 * 60 * 1000, function()
    vim.system(AZ_TOKEN_CMD, { text = true }, function(res)
      if res.code ~= 0 then
        return
      end
      vim.schedule(function()
        local azure = require('atlas.config').provider_options('azure')
        if azure then
          azure.token = vim.trim(res.stdout)
        end
      end)
    end)
  end)
end

local function glab_api(endpoint, cb)
  vim.system({ 'glab', 'api', '--paginate', endpoint }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify('glab api ' .. endpoint .. ' failed: ' .. (res.stderr or ''), vim.log.levels.ERROR)
        return
      end
      -- --paginate concatenates JSON arrays as `][`
      local ok, data = pcall(vim.json.decode, (res.stdout:gsub('%]%s*%[', ',')))
      if not ok then
        vim.notify('Could not parse glab output for ' .. endpoint, vim.log.levels.ERROR)
        return
      end
      cb(data)
    end)
  end)
end

local function open_mrs(view)
  require('atlas').open('pulls', 'gitlab', {
    initial_view = vim.tbl_extend('force', { layout = 'compact', scope = 'all', state = 'opened' }, view),
  })
end

-- Pick a group, then a project in it (or the whole group), and open its open MRs.
local function pick_group_project()
  glab_api('groups?min_access_level=10&per_page=100&order_by=path', function(groups)
    vim.ui.select(groups, {
      prompt = 'GitLab group',
      format_item = function(g)
        return g.full_path
      end,
    }, function(group)
      if not group then
        return
      end
      local endpoint = string.format(
        'groups/%d/projects?include_subgroups=true&archived=false&per_page=100&order_by=last_activity_at',
        group.id
      )
      glab_api(endpoint, function(projects)
        table.insert(projects, 1, { all = true })
        vim.ui.select(projects, {
          prompt = 'Project in ' .. group.full_path,
          format_item = function(p)
            return p.all and ('[all projects in ' .. group.full_path .. ']') or p.path_with_namespace
          end,
        }, function(project)
          if not project then
            return
          end
          if project.all then
            open_mrs({ name = group.full_path, group = group.full_path })
          else
            open_mrs({ name = project.path_with_namespace, project = project.path_with_namespace })
          end
        end)
      end)
    end)
  end)
end

-- Relative paths of every node_modules dir in a checkout (root and monorepo workspaces).
local function find_node_modules(root)
  local found = {}
  for name, type in vim.fs.dir(root, {
    depth = 4,
    skip = function(dir)
      return vim.fs.basename(dir) ~= 'node_modules' and not vim.startswith(vim.fs.basename(dir), '.')
    end,
  }) do
    if type == 'directory' and vim.fs.basename(name) == 'node_modules' then
      table.insert(found, name)
    end
  end
  return found
end

-- Atlas only links the fixed `pulls.diff.lsp.link` paths into the review worktree, so
-- per-workspace node_modules in monorepos (e.g. apps/api/node_modules) are missing and
-- tsserver can't resolve packages. Add whatever the checkout actually has.
-- NOTE: this wraps Atlas' internal `atlas.core.git.worktree.ensure`, not a public API.
-- If an update removes it, the patch is skipped and only `link` below is applied; if
-- its `opts.repo_root` / `opts.link` arguments change, this needs updating.
local function link_workspace_node_modules()
  local ok, worktree = pcall(require, 'atlas.core.git.worktree')
  if not ok or type(worktree.ensure) ~= 'function' then
    return
  end
  local ensure = worktree.ensure
  worktree.ensure = function(opts, on_done)
    if opts and opts.repo_root then
      local link = vim.list_extend({}, opts.link or {})
      for _, path in ipairs(find_node_modules(opts.repo_root)) do
        if not vim.tbl_contains(link, path) then
          table.insert(link, path)
        end
      end
      opts = vim.tbl_extend('force', opts, { link = link })
    end
    return ensure(opts, on_done)
  end
end

-- Point Atlas at the local checkouts under ~/dev, so reviews use them (with their
-- node_modules) instead of cloning into ~/.cache/nvim/atlas/repos. Keys are Atlas'
-- repo ids (e.g. `stijlbreuk/voja/voja-monorepo`, `Product Calculators/ELECSIS_backend`),
-- derived from each checkout's origin URL. Entries in `repo_config.paths` win.
local function map_local_checkouts(root)
  local ok, providers = pcall(require, 'atlas.providers')
  if not ok then
    return
  end
  local options = require('atlas.config').options.pulls
  options.repo_config = options.repo_config or {}
  options.repo_config.paths = options.repo_config.paths or {}
  local paths = options.repo_config.paths

  local git_dirs = vim.fn.systemlist({
    'find', vim.fn.expand(root), '-maxdepth', '5', '-name', '.git', '-type', 'd', '-not', '-path', '*/node_modules/*',
  })
  for _, git_dir in ipairs(git_dirs) do
    local in_origin, url = false, nil
    for _, line in ipairs(vim.fn.readfile(git_dir .. '/config')) do
      if line:match('^%[') then
        in_origin = line:match('^%[remote "origin"%]') ~= nil
      elseif in_origin then
        url = url or line:match('^%s*url%s*=%s*(%S+)')
      end
    end
    local target = url and providers.resolve(url)
    local id = target and target.repo_full_name
    if id and paths[id] == nil then
      paths[id] = vim.fs.dirname(git_dir)
    end
  end
end

-- Atlas' GitLab approve always publishes the pending review (draft_notes/bulk_publish)
-- before approving. With no drafts and no message, GitLab still adds an empty
-- "left review comments" note. Approve directly in that case.
-- NOTE: this wraps Atlas' internal GitLab provider capabilities, not a public API. If
-- an update removes `capabilities.reviews.approve`, the patch is skipped.
local function skip_empty_review_on_approve()
  local ok_provider, provider = pcall(require, 'atlas.pulls.providers.gitlab')
  local ok_service, service = pcall(require, 'atlas.providers.gitlab.client')
  if not (ok_provider and ok_service) then
    return
  end
  local reviews = vim.tbl_get(provider, 'capabilities', 'reviews')
  if type(reviews) ~= 'table' or type(reviews.approve) ~= 'function' then
    return
  end

  local approve = reviews.approve
  reviews.approve = function(pr, review, body, on_done)
    if body and vim.trim(body) ~= '' then
      return approve(pr, review, body, on_done)
    end

    local path, iid = pr.repo_full_name, tonumber(pr.id)
    local prefix = string.format('/projects/%s/merge_requests/%d', service.url_encode(path), iid)
    local ctx = { project_path = path, iid = iid }
    local cancelled, current = false, nil
    local handle = {
      cancel = function()
        cancelled = true
        if current and current.cancel then
          current.cancel()
        end
      end,
    }

    current = service.request('GET', prefix .. '/draft_notes?per_page=1', nil, function(drafts, err)
      if cancelled then
        return
      end
      -- Drafts to publish (or unknown): keep Atlas' publish-then-approve behaviour.
      if err or type(drafts) ~= 'table' or #drafts > 0 then
        current = approve(pr, review, body, on_done)
        return
      end
      current = service.request('POST', prefix .. '/approve', nil, function(_, approve_err)
        if approve_err then
          on_done(false, approve_err)
          return
        end
        -- Same caches Atlas drops after a publish + approve.
        for _, key in ipairs({ 'details', 'reviewers', 'review_metadata' }) do
          service.delete_memory_cache(string.format('gitlab_pulls:%s:%s!%d', key, path, iid))
        end
        service.clear_cache('gitlab_pulls:merge_requests:gql:')
        on_done(true, nil)
      end, vim.tbl_extend('force', ctx, { action = 'Approve MR' }))
    end, vim.tbl_extend('force', ctx, { action = 'Check MR drafts' }))

    return handle
  end
end

return {
  'emrearmagan/atlas.nvim',
  -- Azure DevOps support is still an unmerged draft (emrearmagan/atlas.nvim#87).
  -- Drop this line once it is released.
  branch = 'feat/azure',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    -- 'sindrets/diffview.nvim',
    'dlyongemallo/diffview-plus.nvim'
  },
  cmd = 'Atlas',
  keys = {
    { '<leader>gm', '<cmd>Atlas pulls gitlab<cr>', desc = 'Atlas: merge requests' },
    { '<leader>gM', pick_group_project,            desc = 'Atlas: merge requests by group/project' },
    { '<leader>gA', '<cmd>Atlas pulls azure<cr>',  desc = 'Atlas: Azure DevOps pull requests' },
    { '<leader>gr', '<cmd>Atlas review<cr>',       desc = 'Atlas: review merge request' },
  },
  init = function()
    -- The 80-char guide is noise in Atlas' dashboards and panels.
    vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
      group = vim.api.nvim_create_augroup('magisch_atlas', { clear = true }),
      callback = function(args)
        if vim.bo[args.buf].filetype:match('^atlas') then
          vim.opt_local.colorcolumn = ''
        end
      end,
    })
  end,
  config = function(_, opts)
    require('atlas').setup(opts)
    link_workspace_node_modules()
    skip_empty_review_on_approve()
    refresh_azure_token()
    map_local_checkouts('~/dev')
  end,
  opts = function()
    ---@type AtlasConfig
    return {
      -- <C-s> is the tmux prefix, so it never reaches Neovim.
      keymaps = {
        ui = { submit = '<C-q>' },
        picker = { select = '<CR>' },
      },
      providers = {
        gitlab = {
          base_url = 'https://gitlab.com',
          token = gitlab_token(),
        },
        azure = {
          base_url = 'https://dev.azure.com/corbionarts',
          token = azure_token(),
        },
      },
      pulls = {
        -- Clone repos that aren't checked out locally over SSH: Atlas' HTTPS clone has no
        -- credentials and no terminal to prompt in (Azure DevOps failed on it).
        git_transport = 'ssh',
        diff = {
          open_cmd = 'AtlasDiff',
          layout = 'side-by-side', -- `t` toggles inline in a review
          -- Back the new side with a worktree at the MR head so language servers attach.
          lsp = {
            enabled = true,
            link = { 'node_modules' },
          },
        },
        azure = {
          views = {
            { name = 'Assigned', key = '1', project = 'Product Calculators', scope = 'assigned_to_me' },
            { name = 'Created by me', key = '2', project = 'Product Calculators', scope = 'created_by_me' },
            { name = 'All', key = '3', project = 'Product Calculators', scope = 'all' },
          },
        },
        gitlab = {
          views = {
            {
              name = 'Waiting for review',
              key = '1',
              scope = 'reviews_for_me',
              state = 'opened',
              review_states = { 'UNREVIEWED', 'REVIEW_STARTED' },
            },
            { name = 'Created by me', key = '2', scope = 'created_by_me',  state = 'opened' },
            { name = 'Assigned',      key = '3', scope = 'assigned_to_me', state = 'opened' },
            { name = 'This repo',     key = '4', scope = 'all',            current_repo = true, state = 'opened' },
          },
          bookmarks = {
            items = {
              ['Reviewed by me'] = {
                scope = 'reviews_for_me',
                state = 'opened',
                review_states = { 'REVIEWED', 'REQUESTED_CHANGES', 'APPROVED' },
              },
              ['Changes requested on mine'] = {
                scope = 'created_by_me',
                state = 'opened',
                review_states = { 'REQUESTED_CHANGES' },
              },
            },
          },
        },
      },
    }
  end,
}
