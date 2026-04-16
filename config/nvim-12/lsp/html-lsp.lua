---@type vim.lsp.Config
return {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "teml", "twig, hbs" },
    init_options = {
        provideFormatter = true,
        embeddedLanguage = {
            css = true,
            javascript = true,
        },
        configurationSection = { "html", "css", "javascript" },
    },
    root_markers = {
        "package.json",
        ".git",
    },
    single_file_support = true,
    settings = {},
}
