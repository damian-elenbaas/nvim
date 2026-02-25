return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("typescript-tools").setup({
      settings = {
        tsserver_path = (function()
          -- Try workspace TypeScript first
          local workspace_tsserver = vim.fs.find(
            { "node_modules/typescript/lib/tsserver.js" },
            { upward = true, path = vim.fn.getcwd() }
          )[1]

          if workspace_tsserver then
            return workspace_tsserver
          end

          -- Let typescript-tools use its default
          return nil
        end)(),
      },
    })
  end
}
