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

      kanagawa.load("wave")
    end
  }
}
