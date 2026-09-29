local nvimtree = require("nvim-tree")

nvimtree.setup({
    filters = {
        dotfiles = false,
        git_ignored = true
    },

    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false
    },
    view = {
        width = "15%",
        preserve_window_proportions = true
    },
    git = {
        enable = true
    },
    renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "󰆤",
                modified = "●",
                hidden = "󰜌",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = ""
                },
                git = {
                    staged = "",
                    unstaged = "",
                    renamed = "",
                    untracked = "",
                    deleted = "",
                    ignored = "",
                    unmerged = ""
                }
            }
        }
    }
})

-- OnVimEnter
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function ()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
    end
})

-- Keymap
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { noremap = true, desc = "NvimTree: Focus" })
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { noremap = true, desc = "NvimTree: Toggle" })
