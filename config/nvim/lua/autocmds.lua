local autocmd = vim.api.nvim_create_autocmd

-- Disable auto comment code on new line.
autocmd("FileType", {
	pattern = "*",
	command = "setlocal formatoptions-=cro",
})

-- Set file type
autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*.slint",
	command = "set filetype=slint",
})

autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*hypr*.conf",
	command = "set filetype=hyprlang",
})

-- Enable format on save conform
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			timeout_ms = 500,
			-- lsp_fallback = true,
		})
	end,
})
