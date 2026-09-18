return {
  'stevearc/conform.nvim',
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "oxfmt", "prettierd", stop_after_first = true },
        typescript = { "oxfmt", "prettierd", stop_after_first = true },
        typescriptreact = { "oxfmt", "prettierd", stop_after_first = true },
        php = {},
        -- cs = { "csharpier" },
      },
      formatters = {
        -- Only use oxfmt in projects that have an oxfmt config; otherwise fall through to prettier
        oxfmt = {
          condition = function(_, ctx)
            return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, {
              path = ctx.filename,
              upward = true,
            })[1] ~= nil
          end,
        },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        -- prettierd needs longer on its first run (daemon startup + loading prettier/plugins)
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    })
  end
}
