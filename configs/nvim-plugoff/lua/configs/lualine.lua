local opts = {
	options = {
		component_separators = {
			left = "",
			right = "",
		},
		section_separators = {
			left = "",
			right = "",
		},
		theme = "palenight",
	},
	sections = {
		lualine_b = { "branch" },
	},
}

require("lualine").setup(opts)
