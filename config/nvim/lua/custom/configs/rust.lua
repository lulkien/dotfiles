local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ca", function()
    vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<C-i>", function()
    vim.cmd.RustLsp({ "hover", "range" })
end, { silent = true, buffer = bufnr })

vim.keymap.set("i", "<C-i>", function()
    vim.cmd.RustLsp({ "hover", "range" })
end, { silent = true, buffer = bufnr })
