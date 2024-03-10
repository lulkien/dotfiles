local options = {
	lsp_fallback = false,

	formatters_by_ft = {
		lua = { "stylua" },
		fish = { "fish_indent" },
		yaml = { "yamlfmt" },
		c = { "astyle" },
		cpp = { "astyle" },
		sh = { "shfmt" },
		bash = { "shfmt" },
	},
}

require("conform").setup(options)
