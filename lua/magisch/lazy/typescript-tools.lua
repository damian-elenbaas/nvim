return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  enabled = true,
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  config = function()
    require("typescript-tools").setup({
      settings = {
        tsserver_file_preferences = {
          importModuleSpecifierPreference = "non-relative",
        }
      },
    })
  end
}
