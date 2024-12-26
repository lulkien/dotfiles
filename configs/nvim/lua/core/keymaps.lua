vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Disable arrow keys

map("i", "<Up>", "<Nop>", opts )
map("i", "<Down>", "<Nop>", opts )
map("i", "<Left>", "<Nop>", opts )
map("i", "<Right>", "<Nop>", opts )

-- Resize with arrow keys in normal mode
map("n", "<Up>", "<cmd>resize -2<CR>", opts )
map("n", "<Down>", "<cmd>resize +2<CR>", opts )
map("n", "<Left>", "<cmd>vertical resize -2<CR>", opts )
map("n", "<Right>", "<cmd>vertical resize +2<CR>", opts )

-- Navigate between windows
map("n", "<C-h>", "<cmd>wincmd h<CR>", opts)
map("n", "<C-l>", "<cmd>wincmd l<CR>", opts)
map("n", "<C-j>", "<cmd>wincmd j<CR>", opts)
map("n", "<C-k>", "<cmd>wincmd k<CR>", opts)

-- Windows
map("n", "<leader>sv", "<cmd>wincmd v<CR>", opts)
map("n", "<leader>sh", "<cmd>wincmd s<CR>", opts)
map("n", "<leader>ew", "<cmd>wincmd =<CR>", opts)
map("n", "<leader>cw", "<cmd>wincmd q<CR>", opts)
map("n", "<leader>xw", "<cmd>wincmd q<CR>", opts)


-- Buffers
map("n", "<leader>bn", "<cmd>enew<CR>", opts)
map("n", "<leader>bx", "<cmd>bdelete!<CR>", opts)
map("n", "<leader>bc", "<cmd>bdelete!<CR>", opts)
map("n", "<Tab>", "<cmd>bnext<CR>", opts)
map("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)

-- Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", opts)
map("n", "<leader>tx", "<cmd>tabclose<CR>", opts)
map("n", "<leader>tc", "<cmd>tabclose<CR>", opts)
map("n", "<leader>tn", "<cmd>tabn<CR>", opts)
map("n", "<leader>tp", "<cmd>tabp<CR>", opts)

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<CR>", opts)

-- Modify 'x' key behavior -> Just delete, don't copy into clipboard
map("n", "x", '"_x', opts)

-- Find and centered
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Scroll and centered
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)

-- Line wrapping toggle
map("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Indent mode
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)

-- Keep last yanked when pasting
map("v", "p", '"_dP', opts)

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
