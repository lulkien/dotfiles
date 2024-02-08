return {
	"williamboman/mason.nvim",
	opts = {
		PATH = "skip",

		ensure_installed = {
			"lua-language-server",
			"stylua",
			"bash-language-server",
			"cmake-language-server",
			"pyright",
			"rust-analyzer",
			"slint-lsp",
			"css-lsp",
			"json-lsp",
			"clangd",
			"clang-format",
			"typescript-language-server",
		},

		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},

			keymaps = {
				toggle_server_expand = "<CR>",
				install_server = "i",
				update_server = "u",
				check_server_version = "c",
				update_all_servers = "U",
				check_outdated_servers = "C",
				uninstall_server = "X",
				cancel_installation = "<C-c>",
			},
		},

		max_concurrent_installers = 10,
	},

	config = function(_, opts)
		dofile(vim.g.base46_cache .. "mason")
		require("mason").setup(opts)

		vim.api.nvim_create_user_command("MasonInstallAll", function()
			if opts.ensure_installed and #opts.ensure_installed > 0 then
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end
		end, {})

		vim.g.mason_binaries_list = opts.ensure_installed
	end,
}
