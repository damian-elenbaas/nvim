return {
  "elentok/format-on-save.nvim",
  config = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")
    local vim_notify = require("format-on-save.error-notifiers.vim-notify")

    format_on_save.setup({
      error_notifier = vim_notify,

      exclude_path_patterns = {
        "/node_modules/",
        ".local/share/nvim/lazy",
      },

      formatter_by_ft = {
        css = formatters.lsp,
        cs = formatters.lsp,
        go = formatters.lsp,
        html = formatters.lsp,
        java = formatters.lsp,
        javascript = formatters.lsp,
        json = formatters.lsp,
        lua = formatters.lsp,
        markdown = formatters.prettierd,
        openscad = formatters.lsp,
        python = formatters.black,
        rust = formatters.lsp,
        scad = formatters.lsp,
        scss = formatters.lsp,
        sh = formatters.shfmt,
        terraform = formatters.lsp,
        typescript = formatters.prettierd,
        typescriptreact = formatters.prettierd,
        yaml = formatters.lsp,

        -- Add your own shell formatters:
        -- myfiletype = formatters.shell({ cmd = { "myformatter", "%" } }),

        -- Add custom formatter
        -- filetype1 = formatters.remove_trailing_whitespace,
        -- filetype2 = formatters.custom({ format = function(lines)
        --   return vim.tbl_map(function(line)
        --     return line:gsub("true", "false")
        --   end, lines)
        -- end}),

        -- Use a tempfile instead of stdin
        -- go = {
        --   formatters.shell({
        --     cmd = { "goimports-reviser", "-rm-unused", "-set-alias", "-format", "%" },
        --     tempfile = function()
        --       return vim.fn.expand("%") .. '.formatter-temp'
        --     end
        --   }),
        --   formatters.shell({ cmd = { "gofmt" } }),
        -- },

        -- Add conditional formatter that only runs if a certain file exists
        -- in one of the parent directories.
      },

      -- Optional: fallback formatter to use when no formatters match the current filetype
      fallback_formatter = {
        formatters.remove_trailing_whitespace,
        formatters.remove_trailing_newlines,
      },

      -- By default, all shell commands are prefixed with "sh -c" (see PR #3)
      -- To prevent that set `run_with_sh` to `false`.
      run_with_sh = false,
    })
  end
}
