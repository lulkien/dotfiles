local M = {}

M.crates = {
	n = {
		["<leader>ru"] = {
			function()
				require("crates").upgrade_all_crates()
			end,
			"Rust update crates",
		},
	},
}

return M
