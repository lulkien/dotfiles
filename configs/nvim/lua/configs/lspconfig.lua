local base = require("nvchad.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities
local lspconfig = require("lspconfig")

-- Table of LSP servers
local language_servers = {
	"bashls",
	"clangd",
	"cmake",
	"cssls",
	"jsonls",
	"lua_ls",
	"slint_lsp",
	"pyright",
	"ts_ls",
}

-- Default configs for lsp
for _, lsp in ipairs(language_servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Config for clangd --
-- lspconfig.clangd.setup({
--     on_attach = function(client, bufnr)
--         client.server_capabilities.signatureHelpProvider = false
--         on_attach(client, bufnr)
--     end,
--     capabilities = capabilities,
-- })
