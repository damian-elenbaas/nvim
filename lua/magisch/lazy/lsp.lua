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
    -- Optional
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

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
      }
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
      },
    })

    lsp.setup()
  end
}
