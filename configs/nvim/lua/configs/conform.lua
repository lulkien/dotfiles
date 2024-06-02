local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		fish = { "fish_indent" },
		yaml = { "yamlfmt" },
		c = { "astyle" },
		cpp = { "astyle" },
		sh = { "shfmt" },
		python = { "black" },
		javascript = { "prettierd" },
		toml = { "taplo" },
	},
	-- Manual save with auto command
	-- format_on_save = {
	-- 	lsp_fallback = true,
	-- 	timeout_ms = 500,
	-- },
}

require("conform").setup(options)
