return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        yaml = { "yamlfmt" },
        c = { "astyle" },
        cpp = { "astyle" },
        sh = { "shfmt" },
        python = { "black" },
        javascript = { "prettierd" },
        toml = { "taplo" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
