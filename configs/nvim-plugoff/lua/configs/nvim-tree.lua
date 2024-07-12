local map = vim.keymap.set
local opts = {
	filters = {
		git_ignored = false,
		dotfiles = false,
	},
}

require("nvim-tree").setup(opts)

map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvim Tree Toggle" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Nvim Tree Focus" })
