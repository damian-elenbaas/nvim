return {
  {
    "mason-org/mason.nvim",
    opts = {
      PATH = "prepend",
      registries = {
        'github:mason-org/mason-registry',
        'github:crashdummyy/mason-registry',
      },
    }
  },
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require('mason-lspconfig').setup()
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.lsp.config('*', {
        capabilities = capabilities
      })

      vim.lsp.config("html", {
        filetypes = { 'html', 'razor', 'heex', 'twig' }
      })

      vim.lsp.config("cssls", {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore"
            }
          },
        }
      })

      vim.lsp.config("intelephense", {
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
      })

      --tailwind
      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = {
            validate = true,
            classFunctions = { "cva", "cx" },
          },
        },
        init_options = {
          userLanguages = {
            heex = "html",
            twig = "html"
          }
        }
      })

      vim.lsp.config("emmet_ls", {
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
          -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
          vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { buffer = bufnr })
          vim.keymap.set(
            { 'n', 'x' },
            '<leader>ca',
            '<cmd>lua require("fastaction").code_action()<CR>',
            { desc = "Display code actions", buffer = bufnr }
          )
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
