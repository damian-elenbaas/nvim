local win_config = vim.api.nvim_win_get_config(0)

-- Skip floating windows (like LSP hover)
if win_config.relative ~= "" then
  return
end

vim.opt_local.wrap = false
