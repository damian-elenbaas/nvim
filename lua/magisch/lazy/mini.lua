return {
  "nvim-mini/mini.nvim",
  version = '*',
  config = function()
    require("mini.ai").setup({})
    require("mini.comment").setup({})
    require("mini.move").setup({
      mappings = {
        left = '<C-h>',
        right = '<C-l>',
        down = '<C-j>',
        up = '<C-k>',
      },
    })
    require("mini.surround").setup({})
    require("mini.cursorword").setup({})
    require("mini.pairs").setup({})
    require("mini.trailspace").setup({})
    require("mini.bufremove").setup({})
    require("mini.notify").setup({})

    require("mini.indentscope").setup({
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      },
      symbol = "│"
    })
  end
}
