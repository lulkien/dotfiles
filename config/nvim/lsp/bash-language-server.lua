---@type vim.lsp.Config
return {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_markers = {
        ".git",
    },
    single_file_support = true,
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
        },
    },
}
