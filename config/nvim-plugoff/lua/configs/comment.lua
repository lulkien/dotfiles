require("Comment").setup()

local map = vim.keymap.set

map("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Comment Toggle" })

map(
	"v",
	"<leader>/",
	"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = "Comment Toggle" }
)
