

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- use { "catppuccin/nvim", as = "catppuccin" }
    -- Tokio Night theme
    use { 'folke/tokyonight.nvim', as = 'tokyonight' }
    use { "bluz71/vim-moonfly-colors", as = "moonfly" }

    use({'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'}})
    use('nvim-treesitter/playground')
    use('nvim-treesitter/nvim-treesitter-context')

    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }

    --gcc to comment
    use("numToStr/Comment.nvim")

    use("windwp/nvim-autopairs")
    use("windwp/nvim-ts-autotag")
    -- use {'neoclide/coc.nvim', branch = 'release'}
    -- use ('nvim-tree/nvim-tree.lua')
    -- use ('kyazdani42/nvim-web-devicons')
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use("github/copilot.vim")
    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    -- use('andweeb/presence.nvim')
    -- use 'mfussenegger/nvim-jdtls'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
end)
