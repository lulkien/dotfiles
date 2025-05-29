---@type vim.lsp.Config
return {
  cmd = { "emmylua_ls" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "senele.toml",
    "senele.yaml",
    ".emmyrc.json",
    ".git",
  },
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
}
