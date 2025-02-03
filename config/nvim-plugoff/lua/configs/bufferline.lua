require("bufferline").setup({})

vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR><cmd>bnext<CR>", { desc = "Close current buffer" })
