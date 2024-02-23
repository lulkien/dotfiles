require("custom.setup.keymaps")
require("custom.setup.settings")
require("custom.setup.autocmd")

-- Trim whitespace at end of line
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function()
		vim.cmd([[ %s/\s\+$//e ]])
		vim.cmd([[ write ]])
	end,
})
