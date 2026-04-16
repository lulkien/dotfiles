---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--background-index",
        "--completion-style=bundled",
        "--header-insertion=iwyu",
        "--enable-config",
        "--malloc-trim",
        "--pch-storage=memory",
        "-j=8",
    },
    filetypes = { "c", "cpp" },
    root_markers = {
        ".git",
        "CMakeLists.txt",
        "meson.build",
    },
}
