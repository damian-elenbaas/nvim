return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    local git_blame = require('gitblame')

    -- This disables showing of the blame text next to the cursor
    vim.g.gitblame_display_virtual_text = 0

    local opts = {
      options = {
        component_separators = "",
      },
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
        },
        lualine_x = {
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
