return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
  },
  keys = {
    { '<leader>gs', mode = 'n', '<cmd>Neogit kind=floating<cr>' }
  },
  config = function()
    local neogit = require('neogit')
    neogit.setup {}
  end
}
