return {
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    config = function()
      require("modus-themes").setup({
        style = "modus_vivendi"
      })
    end
  },
  {
    "makestatic/oblique.nvim",
    commit = "b6c40c0c04a756efb2ff42f4fffde352e05eac96",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd("colorscheme oblique")
    end
  },
  {
    "tjdevries/colorbuddy.nvim",
    config = function()
      -- vim.cmd.colorscheme("gruvbuddy")
    end
  },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme("moonfly")
    end
  },
  {
    "0x-ximon/acario.nvim",
    name = "acario",
    lazy = false,
    priority = 1000,
    config = function()
      -- require("acario").setup({})

      -- Select the desired colorscheme variant
      -- vim.cmd("colorscheme acario_light")
      vim.cmd.colorscheme("acario_dark")
    end,
  }
}
