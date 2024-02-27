local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ca", function()
    vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr })

vim.keymap.set("n", "<C-Tab>", function()
    vim.cmd.RustLsp({ "hover", "range" })
end, { silent = true, buffer = bufnr })
