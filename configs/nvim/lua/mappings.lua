local map = vim.keymap.set

------------------------------------- GENERAL KEYMAPS -------------------------------------

-- Disable all arrow keys
map("n", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("i", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("n", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("i", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("n", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("i", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("n", "<Right>", "<Nop>", { desc = "Disable right arrow" })
map("i", "<Right>", "<Nop>", { desc = "Disable right arrow" })

-- Enter command mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertical" })
map("n", "<leader>wh", "<C-w>s", { desc = "split window horizontal" })

-- Buffers
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

-- Clear hl
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })

------------------------------------- SPECIFIC KEYMAPS -------------------------------------

-- CONFORM
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

-- RUST
map("n", "<leader>rcu", function()
	require("crates").upgrade_all_crates()
end, { desc = "Rust crates update" })

map("n", "<leader>ca", function()
	vim.cmd.RustLsp("codeAction")
end, { desc = "Rusty code action" })

-- TAB BUFLINE
map("n", "<tab>", function()
	require("nvchad.tabufline").next()
end, { desc = "Next buffer" })

map("n", "<S-tab>", function()
	require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

map("n", "<leader>bx", function()
	require("nvchad.tabufline").close_buffer()
end, { desc = "Buffer close" })

-- NVIM TREE
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- TELESCOPE
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>gcm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gst", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
	"n",
	"<leader>fa",
	"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
	{ desc = "telescope find all files" }
)

-- WHICHKEY
map("n", "<leader>wk", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })
