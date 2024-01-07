return {
    'williamboman/mason.nvim',
    build = function()
        pcall(vim.cmd, 'MasonUpdate')
    end,
    config = function()
        require("mason").setup()
    end
}
