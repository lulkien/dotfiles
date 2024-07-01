local M = {
{
name = "catppucin",
		url = "https://github.com/catppuccin/nvim/archive/refs/tags/v1.6.0.zip",
		-- Install theme, no need to config
	},
	{
		name = "conform.nvim",
		url = "https://github.com/stevearc/conform.nvim/archive/refs/tags/v5.5.0.zip",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					sh = { "shfmt" },
					fish = { "fish_indent" },
				},
				format_on_save = {
					-- These options will be passed to conform.format()
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		name = "nvim-autopairs",
		url = "https://github.com/windwp/nvim-autopairs/archive/refs/heads/master.zip",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
}

return M
