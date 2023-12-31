return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"clangd",
					"cmake",
					"cssls",
					"jsonls",
					"tsserver",
					"lua_ls",
					"pyright",
					"rust_analyzer",
					"slint_lsp",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local default_lsp = {
				"bashls",
				"clangd",
				"cmake",
				"cssls",
				"jsonls",
				"tsserver",
				"lua_ls",
				"pyright",
				"slint_lsp",
			}

			for _, lsp in ipairs(default_lsp) do
				lspconfig[lsp].setup({
					capabilities = capabilities,
				})
			end

			-- Rust analyzer setup
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				["rust-analyzer"] = {},
			})

			-- Keys binding
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
