vim.pack.add({
	-- Icons
	"https://github.com/nvim-tree/nvim-web-devicons",
	-- Theme
	{
		src = "https://github.com/catppuccin/nvim",
		name = "catppuccin",
	},

	-- Dashboard
	"https://github.com/goolord/alpha-nvim",

	-- Indent line
	"https://github.com/lukas-reineke/indent-blankline.nvim",

	-- Bufferline
	"https://github.com/moll/vim-bbye",
	"https://github.com/akinsho/bufferline.nvim",

	-- Lualine
	"https://github.com/nvim-lualine/lualine.nvim",

	-- Explorer
	"https://github.com/nvim-tree/nvim-tree.lua",

	-- Functional
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/numToStr/Comment.nvim",
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/mrded/nvim-lsp-notify",
	-- "https://github.com/j-hui/fidget.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
	},

	-- Misc
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/ojroques/nvim-osc52",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/NStefan002/screenkey.nvim",

	-- Development
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/ii14/emmylua-nvim",
	"https://github.com/Bilal2453/luvit-meta",
	"https://github.com/stevearc/conform.nvim",
	{
		src = "https://github.com/mrcjkb/rustaceanvim",
		---@diagnostic disable-next-line: need-check-nil
		version = vim.version.range("^9"),
	},
    "https://github.com/alexpasmantier/krust.nvim",

})

require("setup.catppuccin")
require("setup.alpha")

require("setup.indent-blankline")
require("setup.bufferline")
require("setup.lualine")

require("setup.nvim-tree")

require("setup.fzf")
require("setup.comment")
require("setup.treesitter")
require("setup.notify")

require("setup.osc52")
require("setup.autopairs")
require("setup.gitsigns")
require("setup.which-key")
require("setup.screenkey")

require("setup.mason")
require("setup.conform")
require("setup.rust")
