vim.pack.add({
	-- Essential
    "https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/rcarriga/nvim-notify",

    -- Functional
	"https://github.com/mrded/nvim-lsp-notify",
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/ojroques/nvim-osc52",
	"https://github.com/ibhagwan/fzf-lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
		---@diagnostic disable-next-line: need-check-nil
		version = vim.version.range("v2.*"),
	},
	{
		src = "https://github.com/saghen/blink.cmp",
		---@diagnostic disable-next-line: need-check-nil
		version = vim.version.range("v1.*"),
	},

	-- UI
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-mini/mini.icons",
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},

	"https://github.com/goolord/alpha-nvim",
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/moll/vim-bbye",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",

	-- Libraries
	"https://github.com/Bilal2453/luvit-meta",
	"https://github.com/ii14/emmylua-nvim",

	-- For development
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		---@diagnostic disable-next-line: need-check-nil
		version = vim.version.range("^9"),
	},
	"https://github.com/alexpasmantier/krust.nvim",

	-- Misc
	"https://github.com/lewis6991/gitsigns.nvim", -- Git
	"https://github.com/tpope/vim-fugitive", -- Git
	"https://github.com/folke/which-key.nvim",
	"https://github.com/NStefan002/screenkey.nvim",
})

require("config.fzf")
require("config.osc52")
require("config.autopairs")
require("config.notify")
require("config.treesitter")
require("config.blink")

require("config.catppuccin")
require("config.alpha")
require("config.indent-blankline")
require("config.bufferline")
require("config.lualine")
require("config.nvim-tree")

require("config.comment")
require("config.mason")
require("config.conform")
require("config.rust")

require("config.gitsigns")
require("config.which-key")
require("config.screenkey")
