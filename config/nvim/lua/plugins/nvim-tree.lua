---@type LazyConfig
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "catppuccin/nvim",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      filters = {
        dotfiles = false,
        git_ignored = true,
      },

      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = 50,
        preserve_window_proportions = true,
      },
      git = {
        enable = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = "󰈚",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
            },
            git = { unmerged = "" },
          },
        },
      },
    })

    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "NvimTree: Focus" })
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: Toggle" })
  end,
}
