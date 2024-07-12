local opt = vim.opt
local g = vim.g

-- Shell
opt.shell = "/usr/bin/fish"

-- Clipboard
opt.clipboard = "unnamedplus"
opt.cursorline = true
opt.cursorlineopt = "number"

-- Mouse
opt.mouse = ""

-- Case
opt.ignorecase = true
opt.smartcase = true

-- Line number
opt.relativenumber = true
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- Tab size
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true

-- Scroll Offset
opt.scrolloff = 999

-- Disable backup
opt.backup = nil
opt.swapfile = nil
opt.wb = nil

-- Colorscheme
vim.cmd("colorscheme catppuccin-mocha")
