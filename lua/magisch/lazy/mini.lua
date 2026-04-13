return {
  "nvim-mini/mini.nvim",
  version = '*',
  lazy = false,
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
    require("mini.sessions").setup({
      autoread = true
    })
    local write_as_cwd = function()
      local session_name = vim.fn.getcwd():gsub('/', '-')
      MiniSessions.write(session_name)
    end
    vim.keymap.set('n', '<leader>ss', write_as_cwd)
    vim.keymap.set('n', '<leader>ls', function()
      MiniSessions.select()
    end)

    require("mini.indentscope").setup({
      draw = {
        animation = require('mini.indentscope').gen_animation.none(),
      },
      symbol = "│"
    })
  end
}
