return {
    'nvim-treesitter/nvim-treesitter', 
    build = ':TSUpdate',
    config = function()
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { 
                "lua", 
                "vim", 
                "vimdoc", 
                "query", 
                "javascript", 
                "typescript", 
                "c", 
                "rust", 
                "php", 
                "java" 
            },
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
        require 'nvim-treesitter.install'.prefer_git = false
        require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
    end
}
