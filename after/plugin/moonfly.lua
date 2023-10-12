local setup, moonfly = pcall(require, "moonfly")
if not setup then
    return
end

-- Set the theme
vim.cmd.colorscheme "moonfly"
