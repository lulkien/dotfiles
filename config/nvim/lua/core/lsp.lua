---@diagnostic disable: duplicate-type, param-type-not-match
local servers = require("configs.language-servers").servers
local external_servers = require("configs.language-servers").external_servers

-- Load blink capabilities
local blink_ok, blink = pcall(require, "blink-cmp")
if blink_ok then
  vim.lsp.config("*", {
    capabilities = blink.get_lsp_capabilities(),
  })
end

-- Enable language servers
vim.lsp.enable(servers)
vim.lsp.enable(external_servers)

-- Setup virtual line diagnostic
vim.diagnostic.config({
  virtual_lines = true,
})

---@diagnostic disable-next-line: duplicate-type
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
local function LspAttachCallback(args)
  local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

  local fzf = pcall(require, "fzf-lua") and require("fzf-lua") or nil

  ---@class MethodConfig
  ---@field name string         A brief description of what the LSP method does.
  ---@field mode? string        The mode in which the keybinding should be active.
  ---@field keys? string        The keybinding that triggers this LSP method.
  ---@field setup? function()   The function that executes when initializing the LSP method.
  ---@field trigger? function() The function that trigger by keymap.

  ---@type table<string, MethodConfig>
  local method_configs = {
    [vim.lsp.protocol.Methods.textDocument_codeAction] = {
      keys = "<leader>la",
      name = "Code action",
      trigger = fzf and fzf.lsp_code_actions or vim.lsp.buf.code_action,
    },
    [vim.lsp.protocol.Methods.textDocument_references] = {
      name = "Goto references",
      keys = "<leader>lr",
      trigger = fzf and fzf.lsp_references or vim.lsp.buf.references,
    },
    [vim.lsp.protocol.Methods.textDocument_definition] = {
      name = "Goto definition",
      keys = "<leader>ld",
      trigger = fzf and fzf.lsp_definitions or vim.lsp.buf.definition,
    },
    [vim.lsp.protocol.Methods.textDocument_implementation] = {
      name = "Goto implementations",
      keys = "<leader>li",
      trigger = fzf and fzf.lsp_implementatios or vim.lsp.buf.implementation,
    },
    [vim.lsp.protocol.Methods.textDocument_declaration] = {
      name = "Goto declaration",
      keys = "<leader>lD",
      trigger = fzf and fzf.lsp_declarations or vim.lsp.buf.declaration,
    },
    [vim.lsp.protocol.Methods.textDocument_typeDefinition] = {
      name = "Goto type definitions",
      keys = "<leader>lt",
      trigger = fzf and fzf.lsp_typedefs or vim.lsp.buf.type_definition,
    },
    [vim.lsp.protocol.Methods.textDocument_inlayHint] = {
      name = "Toggle inlay hint",
      keys = "<leader>lh",
      setup = function()
        vim.lsp.inlay_hint.enable()
      end,
      trigger = function()
        local hint_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
        vim.lsp.inlay_hint.enable(not hint_enabled)
      end,
    },
    [vim.lsp.protocol.Methods.textDocument_rename] = {
      name = "Rename",
      keys = "<leader>lR",
      trigger = vim.lsp.buf.rename,
    },
    [vim.lsp.protocol.Methods.textDocument_formatting] = {
      name = "Format",
      keys = "<leader>lf",
      trigger = vim.lsp.buf.format,
    },
    [vim.lsp.protocol.Methods.textDocument_hover] = {
      name = "Hover",
      keys = "K",
      trigger = function()
        vim.lsp.buf.hover({
          focusable = false,
          border = "rounded",
        })
      end,
    },
    [vim.lsp.protocol.Methods.textDocument_documentHighlight] = {
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
            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = args2.buf })
          end,
        })
      end,
    },
    -- [vim.lsp.protocol.Methods.textDocument_diagnostic] = {
    --   name = "Diagnostic document",
    --   keys = "<leader>dd",
    --   trigger = fzf and fzf.lsp_document_diagnostics or nil,
    -- },
    -- [vim.lsp.protocol.Methods.workspace_diagnostic] = {
    --   name = "Diagnostic workspace",
    --   keys = "<leader>dw",
    --   trigger = fzf and fzf.lsp_workspace_diagnostics or nil,
    -- },
  }

  -- Loop through the config map and do configure
  for method, config in pairs(method_configs) do
    if client:supports_method(method, args.buf) then
      local mode = config.mode or "n"
      local desc = "LSP: " .. config.name

      if config.setup then
        config.setup()
      end

      if config.keys and config.trigger then
        vim.keymap.set(mode, config.keys, config.trigger, {
          buffer = args.buf,
          desc = desc,
          silent = true,
        })
      end
    end
  end

  -- Force enable lsp diagnostics, I have no idea why i can't check with client supported method
  if fzf then
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
  end
end

-- Create auto commands on LspAttach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = LspAttachCallback,
})
