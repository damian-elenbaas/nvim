return {
  'mbbill/undotree',
  cmd = "UndotreeToggle",
  keys = { { "<leader>u", vim.cmd.UndotreeToggle } },
  init = function()
    -- FC is the Windows diff tool; everywhere else undotree's default diff works.
    if vim.loop.os_uname().sysname == "Windows_NT" then
      vim.g.undotree_DiffCommand = "FC"
    end
  end
}
