return {
  'stevearc/conform.nvim',
  enabled = true,
  opts = {},
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd", stop_after_first = true },
        typescript = { "prettierd", stop_after_first = true },
        php = {},
        -- cs = { "csharpier" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end
}
