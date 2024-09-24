local opts = {
	base46 = {
		theme = "catppuccin", -- default theme
		transparency = false,
	},

	ui = {
		telescope = {
			style = "bordered",
		},

		nvdash = {
			load_on_startup = true,
			header = {
				"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗██████╗ ███████╗",
				"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║██╔══██╗██╔════╝",
				"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██║  ██║█████╗  ",
				"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║  ██║██╔══╝  ",
				"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██████╔╝███████╗",
				"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═════╝ ╚══════╝",
				"                                                       ",
			},
		},
	},
	mason = {
		pkgs = {
			-- "bash-language-server",
			-- "shfmt",
			-- "clangd",
			-- "cmake-language-server",
			-- "lua-language-server",
			-- "stylua",
			-- "pyright",
			-- "black",
			-- "taplo",
			-- "css-lsp",
		},
	},
}

return opts
