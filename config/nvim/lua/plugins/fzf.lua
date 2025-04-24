return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("fzf-lua").setup({ "telescope" })

    vim.keymap.set("n", "<leader>fw", require("fzf-lua").grep_cword, { desc = "Fzf search word" })
    vim.keymap.set("n", "<leader>fW", require("fzf-lua").grep_cWORD, { desc = "Fzf search WORD" })

    vim.keymap.set("n", "<leader>fs", require("fzf-lua").lgrep_curbuf, { desc = "Fzf buffer search" })
    vim.keymap.set("n", "<leader>fS", require("fzf-lua").live_grep_native, { desc = "Fzf project search" })

    vim.keymap.set("n", "<leader>fr", require("fzf-lua").live_grep_resume, { desc = "Fzf resume search" })
    vim.keymap.set("n", "<leader>fR", require("fzf-lua").resume, { desc = "Fzf resume action" })

    vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Fzf find files" })
    vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fzf find buffers" })

    vim.keymap.set("n", "<leader>ft", require("fzf-lua").btags, { desc = "Fzf buffer tags" })
    vim.keymap.set("n", "<leader>fT", require("fzf-lua").tags, { desc = "Fzf project tags" })

    vim.keymap.set("n", "gca", require("fzf-lua").lsp_code_actions(), { desc = "LSP: Code Actions" })
  end,
}
