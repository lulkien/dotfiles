return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = {
                "lua",
                "c",
                "cpp",
                "bash",
                "fish",
                "rust",
                "python",
                "qmljs",
                "javascript",
                "css",
                "scss",
                "cmake",
                "make",
                "json",
                "gitignore"
            },
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}
