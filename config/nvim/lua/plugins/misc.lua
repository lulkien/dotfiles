---@type LazyConfig
local M = {
  {
    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
  },
  {
    -- Powerful Git integration for Vim
    "tpope/vim-fugitive",
  },
  {
    -- GitHub integration for vim-fugitive
    "tpope/vim-rhubarb",
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- {
  --   -- Notification
  --   "echasnovski/mini.notify",
  --   version = "*",
  --   config = function()
  --     require("mini.notify").setup({
  --       lsp_progress = {
  --         enable = true,
  --         level = "INFO",
  --         duration_last = 1000,
  --       },
  --     })
  --   end,
  -- },
  {
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
  },
  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
}

return M
