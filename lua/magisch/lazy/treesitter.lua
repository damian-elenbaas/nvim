return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require'nvim-treesitter.configs'.setup {
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true
            }
        }
        require 'nvim-treesitter.install'.prefer_git = true
        require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
    end
}
