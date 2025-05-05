return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "williamboman/mason.nvim",
      config = true,
    },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "saghen/blink.cmp",
    "ibhagwan/fzf-lua",
  },
  config = function()
    local servers = {
      "bashls",
      "clangd",
      "cssls",
      "html",
      "jsonls",
      "lua_ls",
      "ruff",
      "ts_ls",
      "yamlls",
    }

    local formatters = {
      "clang-format",
      "prettierd",
      "shfmt",
      "stylua",
      "taplo",
      "yamlfmt",
    }

    local ensure_installed = {}
    vim.list_extend(ensure_installed, servers)
    vim.list_extend(ensure_installed, formatters)

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

    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    vim.lsp.config("*", {
      capabilities = require("blink-cmp").get_lsp_capabilities(),
    })

    vim.diagnostic.config({
      virtual_lines = true,
    })

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("<leader>la", require("fzf-lua").lsp_code_actions, "Code Actions")
        map("<leader>lr", require("fzf-lua").lsp_references, "Goto References")
        map("<leader>ld", require("fzf-lua").lsp_definitions, "Goto Definition")
        map("<leader>li", require("fzf-lua").lsp_implementations, "Goto Implementation")
        map("<leader>lD", require("fzf-lua").lsp_declarations, "Goto Declaration")
        map("<leader>lt", require("fzf-lua").lsp_typedefs, "Type Definition")

        map("<leader>lR", vim.lsp.buf.rename, "Rename")
        map("<leader>lf", vim.lsp.buf.format, "Format")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          -- Enable inlay hint
          vim.lsp.inlay_hint.enable()

          map("<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "Toggle Inlay Hints")
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
            end,
          })
        end
      end,
    })
  end,
}
