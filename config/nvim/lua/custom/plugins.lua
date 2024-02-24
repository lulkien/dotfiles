local M = {
    -- "williamboman/mason.nvim",
    -- opts = {
    --     ensure_installed = {
    --         "stylua",
    --         "bash-language-server",
    --         "cmake-language-server",
    --         "pyright",
    --         "css-lsp",
    --         "json-lsp",
    --         "clangd",
    --         "clang-format",
    --         "typescript-language-server",
    --         "rust-analyzer",
    --     },
    -- },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        opts = function()
            return require("custom.configs.none-ls")
        end,
    },
    {
        "rust-lang/rust.vim",
        ft = "rust",
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        config = function()
            require("custom.configs.rust")
        end,
    },
    {
        "saecki/crates.nvim",
        ft = { "rust", "toml" },
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)
            crates.show()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local M = require("plugins.configs.cmp")
            table.insert(M.sources, { name = "crates" })
            return M
        end,
    },
}

return M
