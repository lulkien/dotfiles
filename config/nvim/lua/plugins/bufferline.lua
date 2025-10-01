---@type LazyConfig
return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "moll/vim-bbye",
    "nvim-tree/nvim-web-devicons",
    "catppuccin/nvim",
  },

  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "ordinal", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        buffer_close_icon = "✗",
        close_icon = "✗",
        path_components = 1, -- Show only the file name without the directory
        modified_icon = "●",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = true,
        diagnostics_update_in_insert = true,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = "icon", -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = "󰐃",
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = "insert_at_end",
      },
      highlights = require("catppuccin.special.bufferline").get_theme({
        styles = { "bold" },
      }),
    })

    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer: Cycle next" })
    vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "Buffer: Cycle next" })

    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer: Cycle previous" })
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "Buffer: Cycle previous" })

    vim.keymap.set("n", "<leader>bx", "<cmd>Bdelete<CR>", { desc = "Buffer: Close current" })
    vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Buffer: Close others" })
  end,
}
