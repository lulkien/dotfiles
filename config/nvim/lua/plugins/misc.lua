return {
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
  {
    -- Notification UI
    "j-hui/fidget.nvim",
    opts = {
      integration = {
        ["nvim-tree"] = {
          enable = true,
        },
      },
      notification = {
        window = {
          zindex = 100,
          align = "top",
        },
      },
      progress = {
        lsp = {
          progress_ringbuf_size = 0,
          log_handler = false,
        },
      },
    },
  },
}
