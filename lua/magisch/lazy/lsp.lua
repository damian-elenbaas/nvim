return {
  {
    "williamboman/mason.nvim",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("mason").setup({
        PATH = "prepend",
        registries = {
          'github:mason-org/mason-registry',
          'github:crashdummyy/mason-registry',
        },
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "jsonls",
          "tailwindcss",
          "ts_ls",
          "cssls",
          "lua_ls",
          "angularls",
          "html",
          "intelephense"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "ionide/Ionide-vim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require 'ionide'.setup {
        capabilities = capabilities
      }

      lspconfig.angularls.setup {
        capabilities = capabilities,
        root_dir = util.root_pattern("angular.json", "project.json"),
      }

      lspconfig.html.setup {
        capabilities = capabilities,
        filetypes = { 'html', 'razor', 'heex' }
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

      lspconfig.intelephense.setup {
        capabilities = capabilities,
        root_dir = util.root_pattern("composer.json", ".git"),
        settings = {
          intelephense = {
            files = {
              maxSize = 10000000,
            },
            format = {
              braces = "k&r",
            },
            environment = {
              includePaths = { "vendor", "lib" } -- Ensure vendor is included
            }
          }
        }
      }

      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", ".git"),
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
      }

      --tailwind
      lspconfig.tailwindcss.setup {
        capabilities = capabilities,
        settings = {
          tailwindCSS = {
            validate = true,
          },
        },
        init_options = {
          userLanguages = {
            heex = "html"
          }
        },
        root_dir = function(fname)
          -- Start search from the file's directory and go up to find the Tailwind config inside /assets
          return util.root_pattern("tailwind.config.js", "tailwind.config.ts")(fname)
              or util.root_pattern("assets/tailwind.config.js", "assets/tailwind.config.ts")(fname)
              or util.root_pattern("package.json", ".git")(fname) -- Fallback to project root
        end
      }

      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
        filetypes = {
          "css",
          "elixir",
          "eruby",
          "heex",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "svelte",
          "pug",
          "typescriptreact",
          "vue",
        },
      })

      --golang
      lspconfig.gopls.setup {
        capabilities = capabilities,
        filetypes = { "go", "gomod" },
        root_dir = util.root_pattern("go.mod", ".git"),
      }

      lspconfig.jsonls.setup {
        capabilities = capabilities,
        filetypes = { "json", "jsonc" },
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
          vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, { buffer = bufnr })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr })
          vim.keymap.set("n", "rr", vim.lsp.buf.references, { buffer = bufnr })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { buffer = bufnr })
          vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, { buffer = bufnr })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
          vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, { buffer = bufnr })
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = bufnr })
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = bufnr })
        end,
      })
    end
  },
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
}
