return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",
      "ionide/Ionide-vim",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require("mason").setup({
        PATH = "prepend",
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
      })
      require 'ionide'.setup {
        capabilities = capabilities
      }

      lspconfig.angularls.setup {
        capabilities = capabilities,
        root_dir = util.root_pattern("angular.json", "project.json"),
      }

      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { 'html', 'razor', 'php' }
      }

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
      }

      lspconfig.cssls.setup {
        capabilities = capabilities,
        settings = {
          css = { validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          scss = { validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          less = { validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
        }
      }

      lspconfig.phpactor.setup {
        capabilities = capabilities,
      }

      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
          vim.keymap.set("n", "rr", vim.lsp.buf.references, { buffer = bufnr })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { buffer = bufnr })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = bufnr })
        end,
      })
    end
  }
}
