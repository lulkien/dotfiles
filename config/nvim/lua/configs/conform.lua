local options = {
	lsp_fallback = true,

	formatters_by_ft = {
		lua = { "stylua" },
		fish = { "fish_indent" },
		yaml = { "yamlfmt" },
		c = { "astyle" },
		cpp = { "astyle" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		python = { "black" },
	},
}

require("conform").setup(options)
