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

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
        desc = "Reset C/C++ tabbing because of editorconfig.lua is an ass.",
        pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
        callback = function()
            vim.opt.shiftwidth = 4
            vim.opt.tabstop = 4
        end,
    }),
}
