---@type vim.lsp.Config
return {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp" },
  root_markers = {
    ".clangd",
    ".clang-format",
    ".clang-tidy",
    "compile_commands.json",
    "configure.ac",
    ".git",
  },
}
