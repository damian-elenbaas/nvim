return {
  'tzachar/highlight-undo.nvim',
  keys = { { "u" }, { "<C-r>" } },
  event = "VeryLazy",
  config = function()
    require('highlight-undo').setup()
  end
}
