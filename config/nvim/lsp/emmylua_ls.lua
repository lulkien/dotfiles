---@type vim.lsp.Config
return {
    cmd = { "emmylua_ls" },
    filetypes = { "lua" },
    root_markers = {
        ".emmyrc.json",
        ".git",
    },
}
