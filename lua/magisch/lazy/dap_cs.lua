return {
  -- original
  -- 'nicholasmata/nvim-dap-cs',
  'saul-marquez/nvim-dap-cs',
  branch = 'feat/win-compatibility',
  dependencies = { 'mfussenegger/nvim-dap' },
  config = function()
    local data = vim.fn.stdpath('data')
    local path = data .. "/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe"

    require('dap-cs').setup({
      -- Additional dap configurations can be added.
      -- dap_configurations accepts a list of tables where each entry
      -- represents a dap configuration. For more details do:
      -- :help dap-configuration
      dap_configurations = {
        {
          -- Must be "coreclr" or it will be ignored by the plugin
          type = "coreclr",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },

      netcoredbg = {
        -- the path to the executable netcoredbg which will be used for debugging.
        -- by default, this is the "netcoredbg" executable on your PATH.
        path = path
      }
    })
  end
}
