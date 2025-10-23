return {
  {
    "rebelot/kanagawa.nvim",
    config = function()
      local kanagawa = require("kanagawa")

      ---@diagnostic disable-next-line:missing-fields
      kanagawa.setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none"
              }
            }
          }
        }
      })

      -- kanagawa.load("wave")
    end
  },
  {
    "makestatic/oblique.nvim",
    commit = "b6c40c0c04a756efb2ff42f4fffde352e05eac96",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme oblique")
    end
  }
}
