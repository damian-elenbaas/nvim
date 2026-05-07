vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<C-t>p", ":tabp<CR>")
vim.keymap.set("n", "<C-t>n", ":tabn<CR>")
vim.keymap.set("n", "<C-t>t", ":tabnew<CR>")
vim.keymap.set("n", "<C-t>c", ":tabclose<CR>")
vim.keymap.set("n", "<leader>j", ":m+1<CR>")
vim.keymap.set("n", "<leader>k", ":m-1<CR>")
vim.keymap.set("i", "<C-j>", [[<C-\><C-n>:call search('[>)\]}"'']', 'W')<CR>a]])
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('v', '<leader>p', '"_dP')
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<M-,>", "<C-w>5<")
vim.keymap.set("n", "<M-.>", "<C-w>5>")
vim.keymap.set("n", "<M-[>", "<C-w>5+")
vim.keymap.set("n", "<M-]>", "<C-w>5-")
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>hi', function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { noremap = true, silent = false })
vim.keymap.set("n", "<leader>th", ":botright 16split | terminal<CR>")

local function in_fzf_terminal()
  local ft = vim.bo.filetype
  if ft == "fzf" or ft == "fzf-lua" then
    return true
  end

  local name = vim.api.nvim_buf_get_name(0)
  return name:match("term://.*fzf") ~= nil
end

vim.keymap.set("t", "<c-j>", function()
  if in_fzf_terminal() then
    return "<c-j>"
  end
  return "<c-\\><c-n><c-w><c-j>"
end, { expr = true })

vim.keymap.set("t", "<c-k>", function()
  if in_fzf_terminal() then
    return "<c-k>"
  end
  return "<c-\\><c-n><c-w><c-k>"
end, { expr = true })

vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w><c-h>")
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w><c-l>")
vim.keymap.set("t", "<M-,>", "<c-\\><c-n><C-w>5<")
vim.keymap.set("t", "<M-.>", "<c-\\><c-n><C-w>5>")
vim.keymap.set("t", "<M-[>", "<c-\\><c-n><C-w>5+")
vim.keymap.set("t", "<M-]>", "<c-\\><c-n><C-w>5-")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set('n', '<leader>tl', function()
  vim.diagnostic.open_float({ scope = "line" })
end, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<cr>", { desc = "Close all buffers but the current one" })

vim.api.nvim_create_user_command('LspReset', function()
  vim.cmd("lsp restart")
  vim.diagnostic.reset()
end, { nargs = 0 })

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { desc = "Show LSP Info" })
