--- Safely require a module, return nil on failure.
--- @param module string The module name to require.
--- @param silent? boolean If true, suppresses error messages.
--- @return any|nil loaded_module Returns the module if successful, nil otherwise.
local function safe_require(module, silent)
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

safe_require("core.options")
safe_require("core.keymaps")
safe_require("core.autocmds")

----------------------------------------------- LAZY -----------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end

vim.opt.rtp:prepend(lazypath)

local lazy = require("lazy")

---@diagnostic disable-next-line: undefined-field
lazy.setup({
    spec = {
        -- Theme
        safe_require("plugins.catppuccin"),

        -- UI
        safe_require("plugins.nvim-tree"),
        safe_require("plugins.bufferline"),
        safe_require("plugins.lualine"),
        safe_require("plugins.alpha"),
        safe_require("plugins.indent-blankline"),
        safe_require("plugins.gitsigns"),

        -- Functionality
        safe_require("plugins.fzf"),
        safe_require("plugins.blink"),
        safe_require("plugins.conform"),
        safe_require("plugins.comment"),
        safe_require("plugins.whichkey"),
        safe_require("plugins.screenkey"),
        safe_require("plugins.osc52"),
        safe_require("plugins.misc"),

        -- Devlopment
        safe_require("plugins.treesitter"),
        safe_require("plugins.mason"),

        -- Rust devlopment
        safe_require("plugins.rustaceanvim"),
        safe_require("plugins.crates"),
    },

    install = { colorscheme = { "catppuccin" } },
    checker = { enabled = false },
})

----------------------------------------------- LSP -----------------------------------------------

safe_require("core.lsp")
