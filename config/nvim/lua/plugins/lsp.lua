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
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("grD", vim.lsp.buf.declaration, "Goto Declaration")
        map("grd", require("telescope.builtin").lsp_definitions, "Goto Definition")
        map("grr", require("telescope.builtin").lsp_references, "Goto References")
        map("gri", require("telescope.builtin").lsp_implementations, "Goto Implementation")
        map("grt", require("telescope.builtin").lsp_type_definitions, "Type Definition")
        -- map("grs", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
        map("grs", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("<leader>lth", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "Toggle Inlay Hints")
        end
      end,
    })

    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("blink.cmp").get_lsp_capabilities(default_capabilities)

    local servers = {
      bashls = {},
      clangd = {},
      cssls = {},
      html = { filetypes = { "html", "twig", "hbs" } },
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                "${3rd}/luv/library",
                unpack(vim.api.nvim_get_runtime_file("", true)),
              },
            },
            diagnostics = { disable = { "missing-fields" } },
            format = {
              enable = false,
            },
          },
        },
      },
      ruff = {},
      ts_ls = {},
      yamlls = {},
    }

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

    local ensure_installed = vim.tbl_keys(servers or {})

    vim.list_extend(ensure_installed, {
      "clang-format",
      "prettierd",
      "shfmt",
      "stylua",
      "taplo",
      "yamlfmt",
    })

    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })

    vim.diagnostic.config({
      virtual_lines = true,
    })
  end,
}
