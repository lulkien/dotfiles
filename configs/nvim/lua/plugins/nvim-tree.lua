return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      filters = {
        dotfiles = true,
        git_ignored = false,
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

    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus Nvim Tree" })
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })
  end,
}
