---@type LazyConfig
return {
    "williamboman/mason.nvim",
    -- dependencies = {
    --     "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- },
    opts = {
        ui = {
            icons = {
                package_pending = " ",
                package_installed = " ",
                package_uninstalled = " ",
            },
        },
        PATH = "append",
        max_concurrent_installers = 10,
    },
    -- init = function()
    --     local ensure_installed = {}
    --     vim.list_extend(
    --         ensure_installed,
    --         require("configs.language-servers").servers
    --     )
    --     vim.list_extend(
    --         ensure_installed,
    --         require("configs.language-servers").formatters
    --     )
    --
    --     require("mason").setup({
    --     })
    --
    --     require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    -- end,
}
