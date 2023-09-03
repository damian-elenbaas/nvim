local dap_setup, dap = pcall(require, "dap")
if not dap_setup then
    return
end

local dapui_setup, dapui = pcall(require, "dapui")
if not dapui_setup then
    return
end

-- Setup configurations
dap.adapters.coreclr = {
    type = 'executable',
    command = 'C:/Users/damia/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe',
    args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

-- Key mappings
dapui.setup()
vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>")
vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>")
vim.keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>")
vim.keymap.set("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>")
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
