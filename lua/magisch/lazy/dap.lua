return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    local dapui = require("dapui")

    dapui.setup()

    vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dapui').toggle()<CR>")
    vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
    vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>")
    vim.keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_over()<CR>")
    vim.keymap.set("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>")
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
  end
}
