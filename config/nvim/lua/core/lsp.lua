require("common.utils")

-- Enable configured language servers
local configured_servers = {
	servers = {
		"bash-language-server",
		"clangd",
		"css-lsp",
		"emmylua_ls",
		"html-lsp",
		-- "json-lsp",
        "pyrefly",
		"tombi",
	},
	custom_servers = {
		"qmlls",
	},
}

local servers = configured_servers.servers
local custom_servers = configured_servers.custom_servers

---@type blink.cmp.API|nil
local blink = safe_require("blink.cmp")

if blink then
	vim.lsp.config("*", {
		capabilities = blink.get_lsp_capabilities(),
	})
end

---@class LspMethodConfig
---@field name string           A brief description of what the LSP method does.
---@field mode? string          The mode in which the keybinding should be active.
---@field keys? string          The keybinding that triggers this LSP method.
---@field setup? function()     The function that executes when initializing the LSP method.
---@field callback? function()  The callback function that trigger by keymap.

--- Callback function triggered on LSP attach event.
---
--- @param args vim.api.keyset.create_autocmd.callback_args Event arguments containing:
---   - id: integer Autocommand ID
---   - event: string Name of the triggered event (e.g., "LspAttach")
---   - group?: integer Autocommand group ID, if any
---   - match: string Expanded value of <amatch>
---   - buf: integer Expanded value of <abuf> (buffer number where LSP is attached)
---   - file: string Expanded value of <afile>
---   - data?: any Arbitrary data passed from nvim_exec_autocmds() (includes client_id for LspAttach)
---
--- Configures LSP keybindings and setups for supported methods.
local function lsp_attached_callback(args)
	---@type vim.lsp.Client
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if not client then
		return
	end

	---@type fzf-lua|nil
	local fzf = safe_require("fzf-lua")

	---@type table<string, LspMethodConfig>
	local method_configs = {
		["textDocument/codeAction"] = {
			name = "Code actions",
			keys = "<leader>la",
			callback = fzf and fzf.lsp_code_actions or vim.lsp.buf.code_action,
		},
		["textDocument/references"] = {
			name = "Goto references",
			keys = "<leader>lr",
			callback = fzf and fzf.lsp_references or vim.lsp.buf.references,
		},
		["textDocument/definition"] = {
			name = "Goto definition",
			keys = "<leader>ld",
			callback = fzf and fzf.lsp_definitions or vim.lsp.buf.definition,
		},
		["textDocument/implementation"] = {
			name = "Goto impl.",
			keys = "<leader>li",
			callback = fzf and fzf.lsp_implementations or vim.lsp.buf.implementation,
		},
		["textDocument/declaration"] = {
			name = "Goto declaration",
			keys = "<leader>lD",
			callback = fzf and fzf.lsp_declarations or vim.lsp.buf.declaration,
		},
		["textDocument/typeDefinition"] = {
			name = "Goto typedef.",
			keys = "<leader>lt",
			callback = fzf and fzf.lsp_typedefs or vim.lsp.buf.type_definition,
		},
		["textDocument/inlayHint"] = {
			name = "Toggle inlay hint",
			keys = "<leader>lh",
			setup = function()
				-- Enable inlay hint on startup
				vim.lsp.inlay_hint.enable()
			end,
			callback = function()
				-- Reverse current inlay state
				local inlay_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
				vim.lsp.inlay_hint.enable(not inlay_enabled)
			end,
		},
		["textDocument/rename"] = {
			name = "Rename",
			keys = "<leader>lR",
			callback = vim.lsp.buf.rename,
		},
		["textDocument/hover"] = {
			name = "Hover",
			keys = "K",
			callback = function()
				vim.lsp.buf.hover({
					focusable = false,
					border = "rounded",
				})
			end,
		},
		["textDocument/documentHighlight"] = {
			name = "Document highlight",
			setup = function()
				local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = args.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = args.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
					callback = function(args2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({
							group = "lsp-highlight",
							buffer = args2.buf,
						})
					end,
				})
			end,
		},
		-- Let conform.nvim handle this
		-- ["textDocument/formatting"] = nil,
	}

	-- Iterate config table and config method if client supports
	for method, config in pairs(method_configs) do
		if client:supports_method(method, args.buf) then
			local mode = config.mode or "n"
			local desc = "LSP: " .. config.name

			if config.setup then
				config.setup()
			end

			if config.keys and config.callback then
				vim.keymap.set(mode, config.keys, config.callback, {
					buffer = args.buf,
					desc = desc,
					silent = true,
				})
			end
		end
	end

	-- Force enable lsp diagnostics
	-- I have no idea why i can't check with client supported method
	if fzf then
		-- Using fzf diagnostics
		vim.keymap.set("n", "<leader>dd", fzf.lsp_document_diagnostics, {
			buffer = args.buf,
			desc = "LSP: Document diagnostic",
			silent = true,
		})

		vim.keymap.set("n", "<leader>dw", fzf.lsp_workspace_diagnostics, {
			buffer = args.buf,
			desc = "LSP: Workspace diagnostic",
			silent = true,
		})
	else
		-- Using default vim diagnostics jumping
		map("n", "<leader>dn", function()
			vim.diagnostic.jump({ count = 1 })
		end, { desc = "Diagnostics: Next" })

		map("n", "<leader>dp", function()
			vim.diagnostic.jump({ count = -1 })
		end, { desc = "Diagnostics: Previous" })
	end
end

-- Create auto commands on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = lsp_attached_callback,
})

-- Setup virtual line diagnostic
local diagnostic_opts = {
	signs = { text = signs },
	virtual_lines = false,
	virtual_text = true,
	underline = true, -- Always on
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
}

vim.diagnostic.config(diagnostic_opts)

vim.keymap.set("n", "<leader>ls", function()
	local opts = vim.diagnostic.config() or diagnostic_opts
	local current = opts.virtual_text

	opts.virtual_text = not current
	opts.virtual_lines = current

	vim.diagnostic.config(opts)
end, { desc = "LSP: Switch diagnostic style" })

-- Enable servers
vim.lsp.enable(servers)
vim.lsp.enable(custom_servers)
