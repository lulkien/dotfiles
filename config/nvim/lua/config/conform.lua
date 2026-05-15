require("conform").setup({
	formatters_by_ft = {
		fish = { "fish_indent" },
		yaml = { "yamlfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		sh = { "shfmt" },
		python = { "black" },
		javascript = { "prettierd" },
		nix = { "nixfmt" },
		kdl = { "kdlfmt" },
		lua = { "stylua" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	-- format_on_save = { timeout_ms = 500 },
	format_on_save = nil,
	formatters = {
		shfmt = {
			append_args = { "-i", "4" },
		},
	},
})

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ async = true })
end, {
	noremap = true,
	desc = "LSP: Format buffer",
})

-- OnVimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
})
