vim.opt.mouse = ""

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.ruler = true

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.wrap = false
vim.opt.linebreak = false

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.scrolloff = 15
vim.opt.sidescrolloff = 15

vim.opt.cmdheight = 1
vim.opt.termguicolors = true
vim.opt.pumheight = 10

vim.opt.showtabline = 2

vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.whichwrap:append("bs<>[]hl")
vim.opt.fileencoding = "utf-8"

---------------------------------- vim.g ----------------------------------

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
