---@type LazyConfig
return {
    "NStefan002/screenkey.nvim",
    version = "*",
    opts = {
        win_opts = {
            title = " Screenkey ",
            -- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│", },
        },
        compress_after = 2,
        clear_after = 2,
        disable = {
            filetypes = { "NvimTree" },
        },
    },
    keys = {
        {
            "<leader>ts",
            function() require("screenkey").toggle() end,
            desc = "Toggle: Screenkey"
        }
    },
}
