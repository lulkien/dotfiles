return {
  "saecki/crates.nvim",
  ft = { "rust", "toml" },
  config = function(_, opts)
    local crates = require("crates")
    crates.setup(opts)
    crates.show()

    vim.keymap.set("n", "<leader>rcu", function()
      require("crates").upgrade_all_crates()
    end, { desc = "Rust crates update" })

    vim.keymap.set("n", "<leader>ca", function()
      vim.cmd.RustLsp("codeAction")
    end, { desc = "Rusty code action" })

    vim.keymap.set("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, { silent = true, buffer = vim.api.nvim_get_current_buf() })
  end,
}
