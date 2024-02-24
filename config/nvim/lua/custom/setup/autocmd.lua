local function make_autocmd(events, pattern, command)
    vim.api.nvim_create_autocmd(events, { pattern = pattern, command = command })
end

-- No auto comment
make_autocmd({ "FileType" }, { "*" }, "setlocal formatoptions-=cro")

-- Slint filetype
make_autocmd({ "BufEnter", "BufWinEnter" }, { "*.slint" }, "set filetype=slint")
