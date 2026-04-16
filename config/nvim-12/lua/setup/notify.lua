require("lsp-notify").setup({
	icons = {
		spinner = { "", "", "", "", "", "" }, -- `= false` to disable only this icon
		done = "", -- `= false` to disable only this icon
	},
	notify = require("notify"),
})
