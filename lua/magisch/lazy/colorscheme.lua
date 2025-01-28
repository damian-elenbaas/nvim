function ColorMyPencils(color)
  color = color or "rose-pine"
  vim.cmd.colorscheme(color)

  local highlight_groups = {
    "Normal",
    "NormalNC",
  }

  for _, group in ipairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

return {
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("rose-pine").setup {
  --       disable_background = true,
  --       extend_background_behind_borders = false,
  --       styles = {
  --         bold = true,
  --         italic = true,
  --         transparency = false,
  --       },
  --     }
  --     ColorMyPencils()
  --   end
  -- },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    -- you can set set configuration options here
    config = function()
      vim.o.background = 'dark'
      local settings = {
        darkness = 'stark',
        transparent_background = true,
        colorize_diagnostic_underline_text = true
      }

      vim.g.zenwritten = settings
      vim.cmd([[colorscheme zenwritten]])

      -- Define custom Lush spec
      local lush = require("lush")
      local hsl = lush.hsl

      local custom_highlights = lush(function()
        return {
          -- Very subtle, desaturated green for strings
          String { fg = hsl(120, 15, 65) },

          -- Slightly warm, desaturated red-grey for constants
          Constant { fg = hsl(0, 15, 65) },

          -- Cool grey for color column
          ColorColumn { bg = hsl(220, 5, 15) },

          -- Additional subtle highlights you might want:
          -- Slightly cool grey for comments
          Comment { fg = hsl(220, 10, 55) },

          -- Warm grey for functions
          Function { fg = hsl(30, 15, 70) },

          -- Cool grey for keywords
          Keyword { fg = hsl(220, 15, 75) }
        }
      end)

      -- Apply the custom highlights
      lush.apply(custom_highlights)
    end
  },
}
