return {
  "folke/snacks.nvim",
  config = function()
    require('snacks').setup({
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      image = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      profiler = {
        enabled = true,
      },
    })
    vim.keymap.set('n', '<leader>pp', function()
      require("snacks.profiler").toggle()
    end)
  end
}
