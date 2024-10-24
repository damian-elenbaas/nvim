return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    -- LSP Support
    -- Required
    { 'neovim/nvim-lspconfig' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
    { 'L3MON4D3/LuaSnip' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'onsails/lspkind.nvim' },
    -- Roslyn
    { 'seblj/roslyn.nvim' },
    -- Optional
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'jay-babu/mason-nvim-dap.nvim' }

  },
  build = function()
    pcall(vim.cmd, 'MasonUpdate')
  end,
  config = function()
    local lsp = require('lsp-zero').preset({})

    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)

    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    local lspkind = require('lspkind')

    cmp.setup({
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol', -- show only symbol annotations
          maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
          ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        })
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
    })

    -- Setup up vim-dadbod
    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })

    lsp.set_preferences({
      suggest_lsp_servers = true,
    })

    lsp.on_attach(function(client, bufnr)
      local opts = { buffer = bufnr, remap = false }

      vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
      vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
      vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts)
      vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
      vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
      vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
      vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
      vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end)

    require("mason").setup({
      PATH = "prepend",
    })
    require("mason-nvim-dap").setup({
      ensure_installed = { 'coreclr' },
      automatic_installation = true,
    })
    require('mason-lspconfig').setup({
      ensure_installed = {},
      handlers = {
        lsp.default_setup,
        intelephense = function()
          local lspconfig = require('lspconfig')
          local configs = require('lspconfig.configs')
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          if not configs.intelephense then
            configs.intelephense = {
              default_config = {
                cmd = { 'intelephense', '--stdio' },
                filetypes = { 'php' },
                root_dir = function(fname)
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
          local lspconfig = require('lspconfig')
          lspconfig.angularls.setup {
            root_dir = util.root_pattern("angular.json", "project.json")
          }
        end,
        lua_ls = function()
          local lspconfig = require('lspconfig')
          lspconfig.lua_ls.setup {
            settings = {
              Lua = {
                diagnostics = {
                  globals = { 'vim' }
                }
              }
            }
          }
        end,
        jsonls = function()
          --Enable (broadcasting) snippet capability for completion
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require 'lspconfig'.jsonls.setup {
            capabilities = capabilities,
          }
        end,
        cssls = function()
          local lspconfig = require('lspconfig')
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
              }, }
          }
        end,
        rust_analyzer = function()
          require('lspconfig').rust_analyzer.setup {
            -- Other Configs ...
            settings = {
              ["rust-analyzer"] = {
                -- Other Settings ...
                procMacro = {
                  ignored = {
                    leptos_macro = {
                      -- optional: --
                      -- "component",
                      "server",
                    },
                  },
                },
              },
            }
          }
        end,
        omnisharp = function()
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          local lspconfig = require('lspconfig')
          lspconfig.omnisharp.setup({
            capabilities = capabilities,
            enable_roslyn_analysers = true,
            enable_import_completion = true,
            organize_imports_on_format = true,
            enable_decompilation_support = true,
            filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' }
          })
        end,
      },
    })

    -- DOTNET LSP
    local lspconfig = require('lspconfig')
    require('roslyn').setup({
      config = {
        on_attach = lsp.on_attach,
        root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "*.fsproj"),
      }
    })

    lsp.setup()
  end
}
