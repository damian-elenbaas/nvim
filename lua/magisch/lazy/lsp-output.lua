return {
  "abonckus/lsp-output.nvim",
  event = "LspAttach",
  config = function(_, opts)
    require("lsp-output").setup(opts)

    vim.keymap.set("n", "<leader>lo", require("lsp-output").toggle, { desc = "Toggle LSP output" })
  end,
}
