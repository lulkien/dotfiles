---@type LazyConfig
return {
    "stevearc/conform.nvim",

    config = function()
        ---@type conform.setupOpts
        local opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                fish = { "fish_indent" },
                yaml = { "yamlfmt" },
                c = { "clang-format", lsp_format = "fallback" },
                cpp = { "clang-format", lsp_format = "fallback" },
                sh = { "shfmt" },
                python = { "black" },
                javascript = { "prettierd" },
                toml = { "tombi" },
                nix = { "nixfmt" },
                kdl = { "kdlfmt" },
                cmake = { "cmake-format" },
            },
            format_on_save = {
                lsp_format = "fallback",
            },
            formatters = {
                shfmt = {
                    append_args = { "-i", "4" },
                },
            },
        }

        require("conform").setup(opts)
    end,
}
