return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup()

    vim.keymap.set("n", "<leader>`", "<cmd>ToggleTerm size=20<CR>", { noremap = true, silent = true, desc = "Terminal: Open" })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<CR>]], { buffer = 0 })
        vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<CR>]], { buffer = 0 })
        vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<CR>]], { buffer = 0 })
        vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<CR>]], { buffer = 0 })
      end,
    })
  end,
}
