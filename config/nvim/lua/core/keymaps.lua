vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map({ "n", "v" }, "<Space>", "<Nop>", opts)

-- Disable arrow keys
map("i", "<Up>", "<Nop>", opts)
map("i", "<Down>", "<Nop>", opts)
map("i", "<Left>", "<Nop>", opts)
map("i", "<Right>", "<Nop>", opts)

map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Right>", "<Nop>", opts)

-- Resize with arrow keys in normal mode
-- map("n", "<Up>", "<cmd>resize -2<CR>", { noremap = true, desc = "Resize: height -2" })
-- map("n", "<Down>", "<cmd>resize +2<CR>", { noremap = true, desc = "Resize: height + 2" })
-- map("n", "<Left>", "<cmd>vertical resize -2<CR>", { noremap = true, desc = "Resize: width -2" })
-- map("n", "<Right>", "<cmd>vertical resize +2<CR>", { noremap = true, desc = "Resize: width +2" })

-- Navigate between windows
map("n", "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, desc = "Window: Focus left" })
map("n", "<C-j>", "<cmd>wincmd j<CR>", { noremap = true, desc = "Window: Focus down" })
map("n", "<C-k>", "<cmd>wincmd k<CR>", { noremap = true, desc = "Window: Focus up" })
map("n", "<C-l>", "<cmd>wincmd l<CR>", { noremap = true, desc = "Window: Focus right" })

-- Windows
map("n", "<leader>wv", "<cmd>wincmd v<CR>", { noremap = true, desc = "Window: Split vertical" })
map("n", "<leader>wh", "<cmd>wincmd s<CR>", { noremap = true, desc = "Window: Split horizontal" })
map("n", "<leader>we", "<cmd>wincmd =<CR>", { noremap = true, desc = "Window: Equalize size" })
-- map("n", "<leader>wc", "<cmd>wincmd q<CR>", { noremap = true, desc = "Window: Close" })
map("n", "<leader>wx", "<cmd>wincmd q<CR>", { noremap = true, desc = "Window: Close" })

-- Buffers
map("n", "<leader>bN", "<cmd>enew<CR>", { noremap = true, desc = "Buffer: New" })

-- Tabs
-- map("n", "<leader>to", "<cmd>tabnew<CR>", { noremap = true, desc = "Tab: New" })
-- map("n", "<leader>tx", "<cmd>tabclose<CR>", { noremap = true, desc = "Tab: Close" })
-- map("n", "<leader>tc", "<cmd>tabclose<CR>", { noremap = true, desc = "Tab: Close" })
-- map("n", "<leader>tn", "<cmd>tabn<CR>", { noremap = true, desc = "Tab: Cycle next" })
-- map("n", "<leader>tp", "<cmd>tabp<CR>", { noremap = true, desc = "Tab: Cycle previous" })

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
map("n", "<leader>W", "<cmd>set wrap!<CR>", { noremap = true, desc = "Toggle: Line wrap" })

-- Indent mode
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)

-- Keep last yanked when pasting
map("v", "p", '"_dP', opts)

-- Diagnostic keymaps
map("n", "<leader>dn", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Diagnostics: Next" })

map("n", "<leader>dp", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Diagnostics: Previous" })
--
-- map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostics: Open Floating" })
-- map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics: List" })
