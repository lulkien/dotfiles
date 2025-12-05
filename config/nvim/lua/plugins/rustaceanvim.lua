---@type LazyConfig
return {
    "mrcjkb/rustaceanvim",
    dependencies = {
        {
            "alexpasmantier/krust.nvim",
            ft = "rust",
            opts = {
                keymap = "<leader>k",
                float_win = {
                    border = "rounded",
                    auto_focus = false,
                },
            },
        }
    },
    version = "^6",
    lazy = false,
}
