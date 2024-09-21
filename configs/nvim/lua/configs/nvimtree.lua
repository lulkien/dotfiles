local nvchad_opts = require("nvchad.configs.nvimtree")
local opts = {
	view = {
		width = 60,
	},
	git = { enable = true },
	filters = {
		git_ignored = true,
		dotfiles = true,
	},
}

local options = vim.tbl_deep_extend("force", nvchad_opts, opts)

return options
