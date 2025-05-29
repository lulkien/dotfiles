---@type LazyConfig
return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        yaml = { "yamlfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        sh = { "shfmt" },
        python = { "ruff" },
        javascript = { "prettierd" },
        toml = { "taplo" },
        nix = { "nixfmt" },
        kdl = { "kdlfmt" },
        cmake = { "cmake-format" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
