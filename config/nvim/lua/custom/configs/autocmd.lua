local function autocmd_ft(_pattern, _command)
	vim.api.nvim_create_autocmd("FileType", { pattern = _pattern, command = _command })
end

-- Auto command
autocmd_ft("*", "setlocal formatoptions-=cro")
