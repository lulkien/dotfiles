return {
    servers = {
        -- "bash-language-server",
        "clangd",
        -- "css-lsp",
        "emmylua_ls",
        -- "html-lsp",
        -- "json-lsp",
        "pyright",  -- Python LSP: uncomment 1 at a time
        -- "ruff",     -- Python LSP: uncomment 1 at a time
        "tombi",
    },
    formatters = {
        "clang-format",
        "prettierd",
        "black",
        "shfmt",
        "yamlfmt",
    },
    external_servers = {
        "qmlls",
    },
}
