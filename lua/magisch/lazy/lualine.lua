return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    local git_blame = require('gitblame')

    -- This disables showing of the blame text next to the cursor
    vim.g.gitblame_display_virtual_text = 0

    local opts = {
      options = {
        component_separators = "",
        icons_enabled = true,
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard" }, tabline = { "dashboard" } },
      },
      extensions = { "oil", "lazy" },
      sections = {
        lualine_a = {
          { 'mode', fmt = function(res) return res:sub(1, 1) end }
        },
        lualine_b = { "branch" },
        lualine_c = {
          "filename",
          { "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
          "diagnostics",
          { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          {
            function()
              local is_loaded = vim.api.nvim_buf_is_loaded
              local tbl = vim.api.nvim_list_bufs()
              local loaded_bufs = 0
              for i = 1, #tbl do
                if is_loaded(tbl[i]) then
                  loaded_bufs = loaded_bufs + 1
                end
              end
              return loaded_bufs
            end,
            icon = "B",
            color = { fg = "DarkCyan", gui = "bold" },
          },
        },
        lualine_x = {
          {
            "copilot",
            show_loading = true,
            show_colors = true,
            padding = { right = 1, left = 1 },
            symbols = {
              status = {
                icons = {
                  enabled = " ",
                  sleep = " 󰒲",
                  disabled = " ",
                  warning = " ",
                  unknown = " ",
                },
                hl = {
                  sleep = "#04d1f9",
                },
              },
            },
          },
        },
        lualine_y = {
          "filetype",
        },
        lualine_z = {
          "location"
        }
      },
    }

    return opts
  end,
  dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
}
