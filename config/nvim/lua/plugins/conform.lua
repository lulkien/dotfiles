---@type LazyConfig
return {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    keys = {
        {
            "<leader>lf",
            function()
                require("conform").format({ async = true })
            end,
            desc = "LSP: Format buffer",
        },
    },

    opts = {
        formatters_by_ft = {
            fish = { "fish_indent" },
            yaml = { "yamlfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            sh = { "shfmt" },
            python = { "black" },
            javascript = { "prettierd" },
            nix = { "nixfmt" },
            kdl = { "kdlfmt" },
        },
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- format_on_save = { timeout_ms = 500 },
        format_on_save = nil,
        formatters = {
            shfmt = {
                append_args = { "-i", "4" },
            },
        },
    },

    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,

}
