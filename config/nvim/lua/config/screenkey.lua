require("screenkey").setup({
	win_opts = {
		title = " Screenkey ",
		-- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
	compress_after = 2,
	clear_after = 2,
	disable = {
		filetypes = { "NvimTree" },
	},
})

vim.keymap.set("n", "<leader>ts", function()
	require("screenkey").toggle()
end, { noremap = true, desc = "Toggle: Screenkey" })
