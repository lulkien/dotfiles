-- ---@type LazyConfig
-- local sleuth = {
--   -- Detect tabstop and shiftwidth automatically
--   [1] = "tpope/vim-sleuth",
-- }

---@type LazyConfig
local fugitive = {
    -- Powerful Git integration for Vim
    [1] = "tpope/vim-fugitive",
}

---@type LazyConfig
local rhubarb = {
    -- GitHub integration for vim-fugitive
    [1] = "tpope/vim-rhubarb",
}

---@type LazyConfig
local autopairs = {
    -- Autoclose parentheses, brackets, quotes, etc.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {},
}

---@type LazyConfig
local comments = {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
}

---@type LazyConfig
local colorizer = {
    -- High-performance color highlighter
    "norcalli/nvim-colorizer.lua",
    config = function()
        require("colorizer").setup()
    end,
}

---@type LazyConfig
local notify = {
    "mrded/nvim-lsp-notify",
    dependencies = {
        {
            "rcarriga/nvim-notify",
            config = function()
                ---@diagnostic disable-next-line: assign-type-mismatch
                vim.notify = require("notify")
            end,
        },
    },
    config = function()
        require("lsp-notify").setup()
    end,
}

-- ---@type LazyConfig
-- local hardtime = {
--   "m4xshen/hardtime.nvim",
--   lazy = false,
--   dependencies = { "MunifTanjim/nui.nvim" },
--   opts = {},
-- }

---@type LazyConfig[]
return {
    -- sleuth,
    fugitive,
    rhubarb,
    autopairs,
    comments,
    colorizer,
    notify,
    -- hardtime,
}
