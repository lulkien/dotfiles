vim.lsp.config("rust-analyzer", {
	server = {
		on_attach = function(_client, bufnr)
			vim.keymap.set("n", "<leader>a", function()
				vim.cmd.RustLsp("codeAction")
			end, { silent = true, buffer = bufnr })

			vim.keymap.set("n", "K", function()
				vim.cmd.RustLsp({ "hover", "actions" })
			end, { silent = true, buffer = bufnr })
		end,
	},
})

-- OnFileType
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.rs" },
	callback = function()
		require("krust").setup({
			keymap = "<leader>k", -- Set a keymap for Rust buffers (default: false)
			float_win = {
				border = "rounded", -- Border style: "none", "single", "double", "rounded", "solid", "shadow"
				auto_focus = false, -- Auto-focus float (default: false)
			},
		})
	end,
})
