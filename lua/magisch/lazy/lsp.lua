return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require 'ionide'.setup {
        capabilities = capabilities
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = {},
        ensure_installed = {},
        handlers = {
          html = function()
            lspconfig.html.setup {
              filetypes = { 'html', 'razor' }
            }
          end,
          intelephense = function()
            local configs = require('lspconfig.configs')

            if not configs.intelephense then
              configs.intelephense = {
                default_config = {
                  cmd = { 'intelephense', '--stdio' },
                  filetypes = { 'php' },
                  root_dir = function(_)
                    return vim.loop.cwd()
                  end,
                  settings = {
                    intelephense = {
                      files = {
                        maxSize = 1000000,
                      },
                      format = {
                        braces = "k&r",
                      },
                      environment = {
                      }
                    }
                  }
                }
              }
            end

            lspconfig.intelephense.setup { capabilities = capabilities }
          end,
          angularls = function()
            local util = require("lspconfig.util")
            lspconfig.angularls.setup {
              root_dir = util.root_pattern("angular.json", "project.json")
            }
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup {
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' }
                  },
                  workspace = {
                    library = {
                      vim.fn.expand('$VIMRUNTIME/lua'),
                      vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
                      vim.fn.stdpath('data') .. '/lazy',
                    }
                  }
                }
              }
            }
          end,
          jsonls = function()
            require 'lspconfig'.jsonls.setup {
              capabilities = capabilities,
            }
          end,
          cssls = function()
            lspconfig.cssls.setup {
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
          end,
        },
      })

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
