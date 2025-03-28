return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",

  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },

  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = require("telescope.actions").move_selection_previous, -- move to prev result
            ["<C-j>"] = require("telescope.actions").move_selection_next, -- move to next result
            ["<C-o>"] = require("telescope.actions").select_default, -- open file
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { "node_modules", ".git", ".venv" },
          hidden = true,
        },
      },
      live_grep = {
        file_ignore_patterns = { "node_modules", ".git", ".venv" },
        additional_args = function(_)
          return { "--hidden" }
        end,
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")

    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Find word" })
    vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })

    vim.keymap.set("n", "<leader>fb", function()
      builtin.buffers(require("telescope.themes").get_dropdown({
        winblend = 5,
        previewer = false,
      }))
    end, { desc = "Find buffers" })

    vim.keymap.set("n", "<leader>fib", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        prompt_title = "Find in current buffer",
      }))
    end, { desc = "Find in current buffer" })

    vim.keymap.set("n", "<leader>fia", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Find in all openning buffers",
      })
    end, { desc = "Find in all buffers" })

    -- Git keymap
    vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })
  end,
}
