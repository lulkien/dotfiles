local autocmd = vim.api.nvim_create_autocmd

-- Disable auto comment code on new line.
autocmd("FileType", {
	pattern = "*",
	command = "setlocal formatoptions-=cro",
})
