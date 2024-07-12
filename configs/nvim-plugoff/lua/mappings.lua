local map = vim.keymap.set

-- Command mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Disable all arrow keys
map("n", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("i", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("n", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("i", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("n", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("i", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("n", "<Right>", "<Nop>", { desc = "Disable right arrow" })
map("i", "<Right>", "<Nop>", { desc = "Disable right arrow" })
--
-- Movement
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- <Esc> in normal mode will turn off search highlight
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "No highlight search" })

-- Disable Ctrl-Z to quit in normal mode
map("n", "<C-z>", "<Nop>")

-- Common stuffs
map("x", "<C-c>", "y", { desc = "Copy in visual mode" })
map("n", "<C-c>", "ggVGy", { desc = "Copy all in normal mode" })

map("n", "<C-a>", "ggVG", { desc = "Visual all" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save document" })
map("i", "<C-s>", "<Esc><cmd>w<CR>a", { desc = "Save document" })
