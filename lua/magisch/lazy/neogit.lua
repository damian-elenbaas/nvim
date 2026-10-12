return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "ibhagwan/fzf-lua",
  },
  keys = {
    { '<leader>gs', mode = 'n', '<cmd>Neogit<cr>' },
    {
      '<leader>gc',
      mode = 'n',
      function()
        require('gitblame').get_sha(function(sha)
          if sha == nil or sha == '' or sha:match('^0+$') then
            vim.notify('No commit for this line', vim.log.levels.WARN)
            return
          end
          vim.schedule(function()
            require('neogit.buffers.commit_view').new(sha):open()
          end)
        end)
      end,
      desc = 'Open blame commit of current line in Neogit',
    },
  },
}
