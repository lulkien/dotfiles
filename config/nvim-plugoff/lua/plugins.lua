local M = {
	{
		name = "catppucin",
		url = "https://github.com/catppuccin/nvim/archive/refs/tags/v1.6.0.zip",
		-- Install theme, no need to config
	},
	{
		name = "nvim-web-devicons",
		url = "https://github.com/nvim-tree/nvim-web-devicons/archive/refs/heads/master.zip",
		config = function()
			require("nvim-web-devicons").setup({})
		end,
	},
	{
		name = "nvim-tree.lua",
		url = "https://github.com/nvim-tree/nvim-tree.lua/archive/refs/heads/master.zip",
		config = function()
			require("configs.nvim-tree")
		end,
	},
	{
		name = "lualine.nvim",
		url = "https://github.com/nvim-lualine/lualine.nvim/archive/refs/heads/master.zip",
		config = function()
			require("configs.lualine")
		end,
	},
	{
		name = "bufferline.nvim",
		url = "https://github.com/akinsho/bufferline.nvim/archive/refs/heads/main.zip",
		config = function()
			require("configs.bufferline")
		end,
	},
	{
		name = "conform.nvim",
		url = "https://github.com/stevearc/conform.nvim/archive/refs/tags/v5.5.0.zip",
		config = function()
			require("configs.conform")
		end,
	},
	{
		name = "nvim-autopairs",
		url = "https://github.com/windwp/nvim-autopairs/archive/refs/heads/master.zip",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		name = "Comment.nvim",
		url = "https://github.com/numToStr/Comment.nvim/archive/refs/heads/master.zip",
		config = function()
			require("configs.comment")
		end,
	},
}

return M
