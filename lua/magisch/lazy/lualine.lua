return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "f-person/git-blame.nvim" },
  opts = function()
    local git_blame = require('gitblame')

    -- This disables showing of the blame text next to the cursor
    vim.g.gitblame_display_virtual_text = 0

    -- local acario = {
    --   normal = {
    --     a = { fg = "#0D0E16", bg = "#D85F00", gui = "bold" },
    --     b = { fg = "#CEDBE5", bg = "#1E1E33" },
    --     c = { fg = "#CEDBE5", bg = "#161722" },
    --   },
    --
    --   insert = {
    --     a = { fg = "#0D0E16", bg = "#3679D8", gui = "bold" },
    --     b = { fg = "#CEDBE5", bg = "#1E1E33" },
    --     c = { fg = "#CEDBE5", bg = "#161722" },
    --   },
    --
    --   visual = {
    --     a = { fg = "#0D0E16", bg = "#8041D8", gui = "bold" },
    --     b = { fg = "#CEDBE5", bg = "#1E1E33" },
    --     c = { fg = "#CEDBE5", bg = "#161722" },
    --   },
    --
    --   replace = {
    --     a = { fg = "#0D0E16", bg = "#D83441", gui = "bold" },
    --     b = { fg = "#CEDBE5", bg = "#1E1E33" },
    --     c = { fg = "#CEDBE5", bg = "#161722" },
    --   },
    --
    --   command = {
    --     a = { fg = "#0D0E16", bg = "#79D836", gui = "bold" },
    --     b = { fg = "#CEDBE5", bg = "#1E1E33" },
    --     c = { fg = "#CEDBE5", bg = "#161722" },
    --   },
    --
    --   inactive = {
    --     a = { fg = "#767676", bg = "#161722", gui = "bold" },
    --     b = { fg = "#767676", bg = "#161722" },
    --     c = { fg = "#767676", bg = "#161722" },
    --   },
    -- }

    local colors = {
      bg = "#000000",
      fg = "#ffffff",
      status_bg = "#2a2a6a",
      inactive_bg = "#2d2d2d",
      inactive_fg = "#969696",
      blue = "#79a8ff",
      green = "#44bc44",
      yellow = "#cabf00",
      red = "#ff5f59",
      purple = "#b6a0ff",
    }

    local modus_vivendi_deuteranopia = {
      normal = {
        a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      command = {
        a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
        b = { fg = colors.fg, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.inactive_fg, bg = colors.inactive_bg, gui = "bold" },
        b = { fg = colors.inactive_fg, bg = colors.inactive_bg },
        c = { fg = colors.inactive_fg, bg = colors.inactive_bg },
      },
    }

    local opts = {
      options = {
        theme = modus_vivendi_deuteranopia,
        component_separators = "",
      },
      sections = {
        lualine_a = {
          { 'mode', fmt = function(res) return res:sub(1, 1) end }
        },
        lualine_b = {
          "filename",
          { "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
        },
        lualine_c = {
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
}
