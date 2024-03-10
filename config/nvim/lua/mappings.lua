require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

-- Format with conform
map("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "File Format with conform" })

-- Update all rust crates
map("n", "<leader>rcu", function()
	require("crates").upgrade_all_crates()
end, { desc = "Rust crates update" })

-- Rust keymaps
map("n", "<leader>ca", function()
	vim.cmd.RustLsp("codeAction")
end, { desc = "Rusty code action" })

-- Just kidding
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Disable all arrow keys
map("n", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("i", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("n", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("i", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("n", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("i", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("n", "<Right>", "<Nop>", { desc = "Disable right arrow" })
map("i", "<Right>", "<Nop>", { desc = "Disable right arrow" })
