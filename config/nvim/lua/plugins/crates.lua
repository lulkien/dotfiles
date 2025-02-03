return {
  "saecki/crates.nvim",
  ft = { "rust", "toml" },
  config = function(_, opts)
    local crates = require("crates")
    crates.setup(opts)
    crates.show()

    vim.keymap.set("n", "<leader>rcu", function()
      require("crates").upgrade_all_crates()
    end, { desc = "Rust: Update all crates" })
  end,
}
