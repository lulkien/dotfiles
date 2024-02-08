require("custom.configs.keymaps")
require("custom.configs.settings")
require("custom.configs.autocmd")

-- Trim whitespace at end of line
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function()
		vim.cmd([[ %s/\s\+$//e ]])
		vim.cmd([[ write ]])
	end,
})
