return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup()

    vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-~>", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })

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
