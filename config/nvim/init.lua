--- Safely require a module, return nil on failure.
--- @param module string The module name to require.
--- @param silent? boolean If true, suppresses error messages.
--- @return any|nil loaded_module Returns the module if successful, nil otherwise.
local function try_require(module, silent)
  local ok, loaded = pcall(require, module)
  if not ok then
    if not silent then
      print("Failed to require '" .. module .. "': " .. loaded)
    end
    return {}
  end
  return loaded
end

----------------------------------------------- CORE -----------------------------------------------

try_require("core.options")
try_require("core.keymaps")
try_require("core.autocmds")

----------------------------------------------- LAZY -----------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Theme
    try_require("plugins.catppuccin"),

    -- UI
    try_require("plugins.nvim-tree"),
    try_require("plugins.bufferline"),
    try_require("plugins.lualine"),
    try_require("plugins.alpha"),
    try_require("plugins.indent-blankline"),
    try_require("plugins.gitsigns"),

    -- Functionality
    try_require("plugins.fzf"),
    try_require("plugins.conform"),
    try_require("plugins.comment"),
    try_require("plugins.whichkey"),
    try_require("plugins.screenkey"),
    try_require("plugins.misc"),

    -- Devlopment
    try_require("plugins.treesitter"),
    try_require("plugins.blink"),
    try_require("plugins.lsp11"),

    -- Rust devlopment
    try_require("plugins.rustaceanvim"),
    try_require("plugins.crates"),
  },

  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})
