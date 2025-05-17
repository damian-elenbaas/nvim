return {
  "nvim-tree/nvim-web-devicons",
  config = function()
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN] = '',
          [vim.diagnostic.severity.HINT] = '󰌵',
          [vim.diagnostic.severity.INFO] = '',
        },
      }
    })
  end
}
