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
    -- Omisharp extended
    { 'Hoffs/omnisharp-extended-lsp.nvim' },
    -- Optional
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'jay-babu/mason-nvim-dap.nvim' },
    { 'ionide/Ionide-vim' }

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
        { name = 'nvim_lsp_signature_help' }
      },
      formatting = {
        format = function(entry, vim_item)
          local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
          }

          local highlights_info = require("colorful-menu").cmp_highlights(entry)

          -- Set the kind icon
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

          -- Apply colorful-menu highlights if available
          if highlights_info ~= nil then
            vim_item.abbr_hl_group = highlights_info.highlights
            vim_item.abbr = highlights_info.text
          end

          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
        autocomplete = {
          cmp.TriggerEvent.TextChanged,
          cmp.TriggerEvent.InsertEnter,
        },

        keyword_length = 0,
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
      registries = {
        'github:mason-org/mason-registry',
        'github:crashdummyy/mason-registry',
      },
    })
    require("mason-nvim-dap").setup({
      ensure_installed = { 'coreclr' },
      automatic_installation = true,
    })
    require('mason-lspconfig').setup({
      ensure_installed = {},
      handlers = {
        lsp.default_setup,
        html = function()
          local lspconfig = require('lspconfig')
          lspconfig.html.setup {
            filetypes = { 'html', 'razor' }
          }
        end,
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
          local lspconfig = require('lspconfig')
          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          lspconfig.omnisharp.setup({
            handlers = {
              ["textDocument/definition"] = require('omnisharp_extended').definition_handler,
              ["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
              ["textDocument/references"] = require('omnisharp_extended').references_handler,
              ["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
            },
            capabilities = capabilities,
            enable_roslyn_analysers = true,
            enable_import_completion = true,
            organize_imports_on_format = true,
            enable_decompilation_support = true,
            filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props', 'csx', 'targets' },
            root_dir = function(fname)
              local lspconfig = require 'lspconfig'
              local primary = lspconfig.util.root_pattern '*.sln' (fname)
              local fallback = lspconfig.util.root_pattern '*.csproj' (fname)
              return primary or fallback
            end,
            settings = {
              FormattingOptions = {
                -- Enables support for reading code style, naming convention and analyzer
                -- settings from .editorconfig.
                EnableEditorConfigSupport = true,
                -- Specifies whether 'using' directives should be grouped and sorted during
                -- document formatting.
                OrganizeImports = true,
              },
              msbuild = {
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited. With this
                -- setting enabled OmniSharp may load fewer projects and may thus display
                -- incomplete reference lists for symbols.
                loadProjectsOnDemand = nil,
              },
              RoslynExtensionsOptions = {
                -- Enables support for roslyn analyzers, code fixes and rulesets.
                enableAnalyzersSupport = true,
                -- Enables support for showing unimported types and unimported extension
                -- methods in completion lists. When committed, the appropriate using
                -- directive will be added at the top of the current file. This option can
                -- have a negative impact on initial completion responsiveness,
                -- particularly for the first few completion sessions after opening a
                -- solution.
                enableImportCompletion = true,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                enalyzeOpenDocumentsOnly = nil,
                -- Decompilation support
                enableDecompilationSupport = true,
                -- Inlay Hints
                -- InlayHintsOptions = {
                --   EnableForParameters = true,
                --   ForLiteralParameters = true,
                --   ForIndexerParameters = true,
                --   ForObjectCreationParameters = true,
                --   ForOtherParameters = true,
                --   SuppressForParametersThatDifferOnlyBySuffix = false,
                --   SuppressForParametersThatMatchMethodIntent = false,
                --   SuppressForParametersThatMatchArgumentName = false,
                --   EnableForTypes = true,
                --   ForImplicitVariableTypes = true,
                --   ForLambdaParameterTypes = true,
                --   ForImplicitObjectCreation = true,
                -- },
              },
              Sdk = {
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                IncludePrereleases = true,
              },
            },
          })
        end,
      },
    })

    lsp.setup()

    require 'ionide'.setup {}
  end
}
