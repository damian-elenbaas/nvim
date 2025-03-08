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
      -- vim.cmd([[colorscheme zenwritten]])

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

          Type { fg = hsl(250, 20, 70) },
          NormalFloat { bg = hsl(0, 0, 15) },
          Boolean { fg = hsl(190, 100, 35) },
        }
      end)

      -- Apply the custom highlights
      lush.apply(custom_highlights)
    end
  },
  {
    "tjdevries/colorbuddy.nvim",
    config = function()
      vim.cmd.colorscheme("gruvbuddy")
    end
  }
}
