return {
  {
    "romus204/tree-sitter-manager.nvim",
    enabled = false,
    lazy = false,
    config = function()
      require("tree-sitter-manager").setup({
        border = 'rounded',
        auto_install = true
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not vim.treesitter.language.add(lang) then return end

          if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end

          -- if vim.treesitter.query.get(lang, "folds") then
          --   vim.opt_local.foldmethod = "expr"
          --   vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- end
        end,
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    lazy = false,
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      local highlight = function(bufnr, lang)
        -------------------[ treesitter highlights ]-------------------------------
        if not vim.treesitter.language.add(lang) then
          return vim.notify(
            string.format("Treesitter cannot load parser for language: %s", lang),
            vim.log.levels.INFO,
            { title = "Treesitter" }
          )
        end
        vim.treesitter.start(bufnr)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local bt = vim.bo[args.buf].buftype
          local buf = args.buf

          if bt ~= "" then
            return
          end -- don't run further.

          local ok, treesitter = pcall(require, "nvim-treesitter")
          if not ok then
            return
          end

          --------------------[ treesitter folds ]-------------------------------

          -- if ft == "javascriptreact" or ft == "typescriptreact" then
          --   vim.opt_local.foldmethod = "indent"
          -- else
          --   vim.opt_local.foldmethod = "expr"
          --   vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- end
          --
          -- vim.schedule(function()
          --   -- Only run normal if we're not in terminal mode
          --   if vim.fn.mode() ~= "t" then
          --     vim.cmd "silent! normal! zx"
          --   end
          -- end)

          ---------------------[ treesitter indent ]-------------------------------

          -- only override indentexpr when the parser ships an indents query,
          -- otherwise keep the runtime indent plugin (e.g. GetCSIndent for C#)
          local indent_lang = vim.treesitter.language.get_lang(ft)
          if not vim.tbl_contains({ "python", "html", "yaml", "markdown" }, ft)
              and indent_lang
              and vim.treesitter.language.add(indent_lang)
              and vim.treesitter.query.get(indent_lang, "indents") then
            vim.bo[buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
          end

          --------------------[ treesitter parsers ]-------------------------------
          if vim.fn.executable "tree-sitter" ~= 1 then
            vim.api.nvim_echo({
              {
                "tree-sitter CLI not found. Parsers cannot be installed.",
                "ErrorMsg",
              },
            }, true, {})
            return false
          end

          local lang = vim.treesitter.language.get_lang(ft)
          if not lang then
            return
          end

          if vim.list_contains(treesitter.get_installed(), lang) then
            highlight(buf, lang)
          elseif vim.list_contains(treesitter.get_available(), lang) then
            treesitter.install(lang):await(function()
              highlight(buf, lang)
            end)
          end
        end,
      })
    end,
    opts = {
      install = {
        "comment",
        "css",
        "javascript",
        "markdown",
        "markdown_inline",
        "php",
        "regex",
        "tsx",
        "typescript",
        "vimdoc",
      },
    },
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"
      treesitter.setup(opts)
      if vim.fn.executable "tree-sitter" ~= 1 then
        vim.api.nvim_echo({
          {
            "tree-sitter CLI not found. Parsers cannot be installed.",
            "ErrorMsg",
          },
        }, true, {})
        return false
      end
      treesitter.install(opts.install)
    end,
  }
}
