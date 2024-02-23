local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { silent = true, buffer = bufnr })
