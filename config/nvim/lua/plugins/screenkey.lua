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
      filter = function(keys)
        local ignore = { "h", "j", "k", "l" }
        return vim
          .iter(keys)
          :filter(function(k)
            return not vim.tbl_contains(ignore, k.key)
          end)
          :totable()
      end,
    })

    if not require("screenkey").is_active() then
      require("screenkey").toggle()
    end

    vim.keymap.set("n", "<leader>st", function()
      require("screenkey").toggle()
    end, { desc = "Screenkey: Toggle" })
  end,
}
