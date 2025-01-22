local utils = require("magisch.utils")

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      filetypes = {
        markdown = false,
        help = false,
      },
    },
    config = function()
      require('copilot').setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = "<M-\\>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      })
    end
  },
  {
    "AndreM222/copilot-lualine",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim",                    branch = "master" }, -- for curl, log and async functions
      { "MeanderingProgrammer/render-markdown.nvim" }
    },
    config = function()
      local chat = require("CopilotChat")

      chat.setup {
        model = 'claude-3.5-sonnet',
        highlight_headers = false,
        separator = '---',
        error_header = '> [!ERROR] Error',

        prompts = {
          Explain = {
            mapping = '<leader>ae',
            description = 'AI Explain',
          },
          Review = {
            mapping = '<leader>ar',
            description = 'AI Review',
          },
          Tests = {
            mapping = '<leader>at',
            description = 'AI Tests',
          },
          Fix = {
            mapping = '<leader>af',
            description = 'AI Fix',
          },
          Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimize',
          },
          Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentation',
          },
          Commit = {
            mapping = '<leader>ac',
            description = 'AI Generate Commit',
          },
        },
        window = {
          width = 0.3,
        },
      }

      utils.au('BufEnter', {
        pattern = 'copilot-*',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt.colorcolumn = ''
        end,
      })

      vim.keymap.set({ 'n' }, '<leader>aa', chat.toggle, { desc = 'AI Toggle' })
      vim.keymap.set({ 'v' }, '<leader>aa', chat.open, { desc = 'AI Open' })
      vim.keymap.set({ 'n' }, '<leader>ax', chat.reset, { desc = 'AI Reset' })
      vim.keymap.set({ 'n' }, '<leader>as', chat.stop, { desc = 'AI Stop' })
      vim.keymap.set({ 'n' }, '<leader>am', chat.select_model, { desc = 'AI Model' })
    end
    -- See Commands section for default commands if you want to lazy load on them
  },
}
