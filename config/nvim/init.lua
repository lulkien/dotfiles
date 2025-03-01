require("core.options")
require("core.keymaps")
require("core.autocmds")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Theme
    require("plugins.catppuccin"),
    require("plugins.mini-icons"),

    -- UI
    require("plugins.nvim-tree"),
    require("plugins.bufferline"),
    require("plugins.lualine"),
    require("plugins.alpha"),
    require("plugins.indent-blankline"),
    require("plugins.gitsigns"),

    -- Functionality
    require("plugins.telescope"),
    require("plugins.conform"),
    require("plugins.comment"),
    require("plugins.whichkey"),
    require("plugins.misc"),

    -- Devlopment
    require("plugins.treesitter"),
    require("plugins.cmp"),
    require("plugins.lsp"),
    -- require("plugins.toggleterm"),

    -- Rust devlopment
    require("plugins.rustaceanvim"),
    require("plugins.crates"),
  },

  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})
