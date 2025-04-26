---@diagnostic disable: unused-local
return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local Position = {
      TopLeft = 1,
      Top = 2,
      TopRight = 3,
      Right = 4,
      BottomRight = 5,
      Bottom = 6,
      BottomLeft = 7,
      Left = 8,
    }
    local double_border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }

    require("fzf-lua").setup({
      { "fzf-native" },
      winopts = {
        border = double_border,
      },
    })

    vim.keymap.set("n", "<leader>fw", require("fzf-lua").grep_cword, { desc = "Fuzzy: Search word" })
    vim.keymap.set("n", "<leader>fW", require("fzf-lua").grep_cWORD, { desc = "Fuzzy: Search WORD" })

    vim.keymap.set("n", "<leader>fs", require("fzf-lua").lgrep_curbuf, { desc = "Fuzzy: Search in buffer" })
    vim.keymap.set("n", "<leader>fS", require("fzf-lua").live_grep_native, { desc = "Fuzzy: Search in project" })

    vim.keymap.set("n", "<leader>fr", require("fzf-lua").live_grep_resume, { desc = "Fuzzy: Resume search" })
    vim.keymap.set("n", "<leader>fR", require("fzf-lua").resume, { desc = "Fuzzy: Resume action" })

    vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Fuzzy: Find files" })
    vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fuzzy: Find buffer" })

    -- vim.keymap.set("n", "<leader>ft", require("fzf-lua").btags, { desc = "Fuzzy: Buffer tags" })
    -- vim.keymap.set("n", "<leader>fT", require("fzf-lua").tags, { desc = "Fuzzy: Project tags" })
  end,
}
