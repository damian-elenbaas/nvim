return {
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
          -- Very subtle, desaturated green for strings (increased saturation and lightness)
          String { fg = hsl(120, 25, 70) },

          -- Slightly warm, desaturated red-grey for constants (increased saturation and lightness)
          Constant { fg = hsl(0, 25, 70) },
          Number { fg = hsl(0, 25, 70) },

          -- Cool grey for color column (darker background)
          ColorColumn { bg = hsl(220, 8, 12) },

          -- Slightly cool grey for comments (increased saturation, decreased lightness for better contrast)
          Comment { fg = hsl(220, 15, 50) },

          -- Slightly warm, subtle yellow for functions
          Function { fg = hsl(50, 25, 70) },

          Type { fg = hsl(250, 20, 70) },
          NormalFloat { bg = hsl(0, 0, 15) },
          Boolean { fg = hsl(190, 100, 35) },

          -- Bright gray for current line number
          LineNrAbove { fg = hsl(0, 0, 55) },
          LineNr { fg = hsl(0, 0, 85) },
          LineNrBelow { fg = hsl(0, 0, 55) },
        }
      end)

      -- Apply the custom highlights
      lush.apply(custom_highlights)
    end
  },
}
