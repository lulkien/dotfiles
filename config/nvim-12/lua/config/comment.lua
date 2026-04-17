require("Comment").setup({})

local api = require("Comment.api")

vim.keymap.del("n", "gc")
vim.keymap.del("n", "gcc")
vim.keymap.del("n", "gb")
vim.keymap.del("n", "gbc")

vim.keymap.set("n", "<leader>/", api.toggle.linewise.current, { noremap = true, desc = "Comment: Toggle" })
vim.keymap.set(
	"v",
	"<leader>/",
	"<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ noremap = true, desc = "Comment: Toggle" }
)
