return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false,
  -- config = function()
  --   vim.keymap.set("n", "<leader>ca", function()
  --     vim.cmd.RustLsp("codeAction")
  --   end, { desc = "Rust: Code action" })
  --
  --   vim.keymap.set("n", "K", function()
  --     vim.cmd.RustLsp({ "hover", "actions" })
  --   end, { silent = true, buffer = vim.api.nvim_get_current_buf() })
  -- end,
}
