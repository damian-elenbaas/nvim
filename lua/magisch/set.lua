local opt = vim.opt

opt.autoindent = true
opt.backup = false
opt.colorcolumn = "80"
opt.expandtab = true
opt.isfname:append("@-@")
opt.nu = true
opt.relativenumber = true

opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 8
opt.shiftwidth = 4
opt.signcolumn = "yes"
opt.softtabstop = 4
opt.swapfile = false
opt.tabstop = 4
opt.termguicolors = true
opt.updatetime = 50
opt.shada = { "'10", "<0", "s10", "h" }
opt.clipboard = "unnamedplus"

opt.wrap = true
opt.splitbelow = true
opt.splitright = true

vim.cmd("language en_US.UTF-8")
vim.g["fsharp#lsp_recommended_colorscheme"] = 0

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
