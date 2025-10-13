---@diagnostic disable: unused-local, unused-function
---@type LazyConfig
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
      { "default-title" },
      number = false,
      fzf_bin = "sk",

      winopts = {
        border = function(_, m)
          assert(m.type == "nvim" and m.name == "fzf")
          if m.nwin == 1 then
            return double_border
          end

          assert(type(m.layout) == "string")

          local b = vim.deepcopy(double_border)

          if m.layout == "down" then
            b[Position.Bottom] = ""
          elseif m.layout == "up" then
            b[Position.Top] = ""
          elseif m.layout == "left" then
            b[Position.Left] = ""
          else -- right
            b[Position.Right] = ""
          end

          return b
        end,

        preview = {
          scrollbar = "float",

          border = function(_, m)
            if m.type == "fzf" then
              return double_border
            end

            assert(m.type == "nvim" and m.name == "prev" and type(m.layout) == "string")

            local b = vim.deepcopy(double_border)

            if m.layout == "down" then
              b[Position.TopLeft] = "╟"
              b[Position.Top] = "─"
              b[Position.TopRight] = "╢"
            elseif m.layout == "up" then
              b[Position.BottomRight] = "╢"
              b[Position.Bottom] = "─"
              b[Position.BottomLeft] = "╟"
            elseif m.layout == "left" then
              b[Position.TopRight] = "╤"
              b[Position.Right] = "│"
              b[Position.BottomRight] = "╧"
            else -- right
              b[Position.TopLeft] = "╤"
              b[Position.Left] = "│"
              b[Position.BottomLeft] = "╧"
            end

            return b
          end,
        },
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
