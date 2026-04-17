local bufferline = require("bufferline")

bufferline.setup({
	options = {
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slope",
		indicator = {
			style = "underline",
		},
	},
})

-- Keybinding
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { noremap = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { noremap = true })
vim.keymap.set("n", "<leader>bx", "<cmd>Bdelete<CR>", { noremap = true, desc = "Buffer: Close current" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { noremap = true, desc = "Buffer: Close others" })
vim.keymap.set("n", "<leader>bcc", "<cmd>Bdelete<CR>", { noremap = true, desc = "Buffer: Close current" })
vim.keymap.set("n", "<leader>bco", "<cmd>BufferLineCloseOthers<CR>", { noremap = true, desc = "Buffer: Close others" })
vim.keymap.set("n", "<leader>bch", "<cmd>BufferLineCloseLeft<CR>", { noremap = true, desc = "Buffer: Close left" })
vim.keymap.set("n", "<leader>bcl", "<cmd>BufferLineCloseRight<CR>", { noremap = true, desc = "Buffer: Close right" })

