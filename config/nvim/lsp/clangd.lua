---@type vim.lsp.Config
return {
  cmd = {
    "clangd",
    "--compile-commands-dir=build",
    "--background-index",
    "--background-index-priority=normal",
    "--completion-style=bundled",
    "--experimental-modules-support",
    "--header-insertion=iwyu",
    "--enable-config",
    "--malloc-trim",
    "--pch-storage=memory",
    "-j",
    "8",
  },

  filetypes = { "c", "cpp" },
  root_markers = {
    ".git",
    ".clangd",
    ".clang-format",
    "CMakeLists.txt",
    "meson.build",
  },
}
