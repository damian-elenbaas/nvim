return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    if vim.loop.os_uname().sysname ~= "Linux" then
      vim.g.undotree_DiffCommand = "FC"
    end
  end
}
