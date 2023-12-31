local treesitter_opts = {
	"nvim-treesitter/nvim-treesitter",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"lua",
				"c",
				"cpp",
				"bash",
				"fish",
				"rust",
				"python",
				"qmljs",
				"javascript",
				"css",
				"scss",
				"cmake",
				"make",
				"json",
				"gitignore",
			},
			highlight = {
				enable = true,
        use_languagetree = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}

return treesitter_opts
