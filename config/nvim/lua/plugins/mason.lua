---@type LazyConfig
return {
    "williamboman/mason.nvim",
    dependencies = {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local ensure_installed = {}
        vim.list_extend(
            ensure_installed,
            require("configs.language-servers").servers
        )
        vim.list_extend(
            ensure_installed,
            require("configs.language-servers").formatters
        )

        require("mason").setup({
            ui = {
                icons = {
                    package_pending = " ",
                    package_installed = " ",
                    package_uninstalled = " ",
                },
            },
            PATH = "append",
            max_concurrent_installers = 10,
        })

        -- require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    end,
}
