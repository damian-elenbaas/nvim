return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "ibhagwan/fzf-lua",
  },
  keys = {
    { '<leader>gs', mode = 'n', '<cmd>Neogit<cr>' }
  },
}
