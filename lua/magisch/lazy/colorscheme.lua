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
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        disable_background = true,
        extend_background_behind_borders = false,
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
      }
      ColorMyPencils()
    end
  }
}
