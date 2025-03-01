return {
  "numToStr/Comment.nvim",
  opts = {},
  config = function()
    local opts = { noremap = true, desc = "Comment: Toggle" }
    vim.keymap.set("n", "<leader>/", require("Comment.api").toggle.linewise.current, opts)
    vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
    vim.keymap.del("n", "gc")
    vim.keymap.del("n", "gcc")
  end,
}
