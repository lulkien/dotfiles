local M = {
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = { enable = true },
			filters = {
				git_ignored = true,
				dotfiles = true,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = require("configs.treesitter"),
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig")
			require("configs.lspconfig")
		end,
	},
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
	},
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
		end,
	},
}

return M
