---@type LazyConfig
return {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    opts = {},
    keys = function()
        local crates = require("crates")
        return {
            { "<leader>rcu", crates.update_all_crates, desc = "Rust: Update all crates" }
        }
    end,
}
