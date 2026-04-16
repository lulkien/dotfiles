require("mason").setup({
	ui = {
		icons = {
			package_pending = " ",
			package_installed = " ",
			package_uninstalled = " ",
		},
	},
	PATH = "append",
	max_concurrent_installers = 10,
})
