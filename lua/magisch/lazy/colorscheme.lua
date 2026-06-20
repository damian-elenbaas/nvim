return {
  {
    "miikanissi/modus-themes.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      require("modus-themes").setup({
        style = "modus_vivendi",
        variants = {
          modus_vivendi = "deuteranopia", -- Set variant for `modus_vivendi` style
        },
      })

      -- vim.cmd.colorscheme("modus")
    end
  },
  {
    "makestatic/oblique.nvim",
    enabled = false,
    commit = "b6c40c0c04a756efb2ff42f4fffde352e05eac96",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme oblique")
    end
  },
  {
    "tjdevries/colorbuddy.nvim",
    enabled = false,
    config = function()
      -- vim.cmd.colorscheme("gruvbuddy")
    end
  },
  {
    "bluz71/vim-moonfly-colors",
    enabled = false,
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("moonfly")
    end
  },
  {
    "0x-ximon/acario.nvim",
    enabled = false,
    name = "acario",
    lazy = false,
    priority = 1000,
    config = function()
      -- require("acario").setup({})

      -- Select the desired colorscheme variant
      -- vim.cmd("colorscheme acario_light")
      -- vim.cmd.colorscheme("acario_dark")
      -- vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#ffffff" })
    end,
  },
  {
    "szymonwilczek/arete.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      local arete = require("arete")

      arete.setup({
        -- Enable transparent background for the editor
        transparent = false,

        -- Use the bytecode cache engine (highly recommended for performance)
        cache = true,

        -- Set specific styles for specific syntax highlight groups
        -- Can be any valid attr-list value. See `:h nvim_set_hl`
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          types = { bold = true },
          functions = {},
          variables = {},
        },
      })

      -- To apply a theme, simply use the standard Neovim colorscheme command
      -- vim.cmd.colorscheme("modus-vivendi-deuteranopia")
    end
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
        styles = {
          italic = false,
          transparency = true
        }
      })
      -- vim.cmd("colorscheme rose-pine")
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        transparent_background = true
      })
      vim.cmd("colorscheme catppuccin")
    end
  }
}
