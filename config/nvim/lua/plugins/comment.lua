---@diagnostic disable: undefined-global
---@type LazyConfig
return {
    "numToStr/Comment.nvim",
    opts = {},
    keys = function()
        vim.keymap.del("n", "gc")
        vim.keymap.del("n", "gcc")

        local api = require("Comment.api")

        return {
            { "<leader>/", mode = { "n" }, api.toggle.linewise.current, desc = "Comment: Toggle" },
            {
                "<leader>/",
                mode = { "v" },
                "<Esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                desc = "Comment: Toggle"
            },
        }
    end,
}
