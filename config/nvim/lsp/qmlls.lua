---@type vim.lsp.Config
return {
  cmd = { "qmlls6" },
  filetypes = { "qml" },
  root_markers = {
    ".git",
    ".qmlls.ini",
  },
  single_file_support = true,
}
