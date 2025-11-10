---@type vim.lsp.Config
return {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        "requirements.txt",
        ".git",
    },
    single_file_support = true,
}
