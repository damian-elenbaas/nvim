return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("todo-comments").setup()
  end,
  keys = {
    { "<leader>tt", "<cmd>Trouble todo<cr>", desc = "Show all todos" }
  }
}
