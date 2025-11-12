---@type LazyConfig
return {
    "williamboman/mason.nvim",
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
}
