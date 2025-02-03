return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = {
    "catppuccin/nvim",
  },
  main = "ibl",
  config = function()
    local highlight = {
      "CatppuccinRed",
      "CatppuccinYellow",
      "CatppuccinBlue",
      "CatppuccinPeach",
      "CatppuccinGreen",
      "CatppuccinMauve",
      "CatppuccinRosewater",
    }

    local hooks = require("ibl.hooks")
    local mocha = require("catppuccin.palettes").get_palette("mocha")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "CatppuccinRed", { fg = mocha.red })
      vim.api.nvim_set_hl(0, "CatppuccinYellow", { fg = mocha.yellow })
      vim.api.nvim_set_hl(0, "CatppuccinBlue", { fg = mocha.blue })
      vim.api.nvim_set_hl(0, "CatppuccinPeach", { fg = mocha.peach })
      vim.api.nvim_set_hl(0, "CatppuccinGreen", { fg = mocha.green })
      vim.api.nvim_set_hl(0, "CatppuccinMauve", { fg = mocha.mauve })
      vim.api.nvim_set_hl(0, "CatppuccinRosewater", { fg = mocha.rosewater })
    end)

    require("ibl").setup({
      indent = {
        char = "▏",
        -- highlight = highlight,
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = false,
      },
      exclude = {
        filetypes = {
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Trouble",
        },
      },
    })
  end,
}
