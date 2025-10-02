---@type LazyConfig
return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*",
  config = function()
    require("screenkey").setup({
      win_opts = {
        title = " Screenkey ",
        -- border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
      compress_after = 2,
      clear_after = 2,
      disable = {
        filetypes = { "NvimTree" },
      },
    })

    if not require("screenkey").is_active() then
      require("screenkey").toggle()
    end

    vim.keymap.set("n", "<leader>ts", function()
      require("screenkey").toggle()
    end, { desc = "Toggle: Screenkey" })
  end,
}
