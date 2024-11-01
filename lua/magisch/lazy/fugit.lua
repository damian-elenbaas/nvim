return {
  'SuperBo/fugit2.nvim',
  opts = {
    width = 150,
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-lua/plenary.nvim',
    {
      'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
      dependencies = { 'stevearc/dressing.nvim' }
    },
  },
  cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph' },
  keys = {
    { '<leader>gs', mode = 'n', '<cmd>Fugit2<cr>' }
  }
}
