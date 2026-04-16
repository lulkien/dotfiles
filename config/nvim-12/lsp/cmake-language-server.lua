---@type vim.lsp.Config
return {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    root_markers = {
        "CMakeLists.txt",
        ".git",
    },
}
