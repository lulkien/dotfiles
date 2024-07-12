require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		sh = { "shfmt" },
		fish = { "fish_indent" },
		c = { "astyle" },
		cpp = { "astyle" },
		python = { "black" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

vim.keymap.set("n", "<leader>fm", function()
	require("conform").format()
end, { desc = "Format Files" })
