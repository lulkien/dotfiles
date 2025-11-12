---@type LazyConfig
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false,
    opts = {
        ensure_installed = { "lua" },
        auto_install = true,
        highlight = {
            enable = true,
        },
        indent = {
            enable = true,
        },
    },
}
