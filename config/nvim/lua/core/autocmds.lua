return {
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        command = "setlocal formatoptions-=cro",
    }),

    -- File types
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = "hypr*.conf",
        command = "set ft=hyprlang",
    }),
}
