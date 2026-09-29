require("agentic").setup({
	-- Hermes Agent speaks ACP over stdio through the hermes-acp adapter.
	provider = "hermes",

	acp_providers = {
		hermes = {
			name = "Hermes",
			command = "hermes-acp",
		},

		-- Any other ACP provider CLI works too, e.g.:
		-- pnpm add -g @agentclientprotocol/claude-agent-acp
		-- ["claude-agent-acp"] = {
		-- 	name = "Claude Agent ACP",
		-- 	command = "claude-agent-acp",
		-- },
	},

	windows = {
		position = "right",
		width = "35%",
	},
})

local map = vim.keymap.set

map("n", "<leader>aa", "<cmd>lua require('agentic').toggle()<CR>", { desc = "Agentic: Toggle chat" })
map("n", "<leader>an", "<cmd>lua require('agentic').new_session()<CR>", { desc = "Agentic: New session" })
map("n", "<leader>al", "<cmd>lua require('agentic').select_session()<CR>", { desc = "Agentic: Select session" })
map("n", "<leader>ar", "<cmd>lua require('agentic').restore_session()<CR>", { desc = "Agentic: Restore session" })
map("n", "<leader>ax", "<cmd>lua require('agentic').destroy_session()<CR>", { desc = "Agentic: Destroy session" })
map("n", "<leader>ac", "<cmd>lua require('agentic').stop_generation()<CR>", { desc = "Agentic: Stop generation" })
map(
	{ "n", "v" },
	"<leader>as",
	"<cmd>lua require('agentic').add_selection_or_file_to_context()<CR>",
	{ desc = "Agentic: Add selection/file to context" }
)
map(
	"n",
	"<leader>ad",
	"<cmd>lua require('agentic').add_current_line_diagnostics()<CR>",
	{ desc = "Agentic: Add line diagnostics" }
)
map(
	"n",
	"<leader>aD",
	"<cmd>lua require('agentic').add_buffer_diagnostics()<CR>",
	{ desc = "Agentic: Add buffer diagnostics" }
)

require("which-key").add({
	{ "<leader>a", group = "Agentic", mode = { "n", "v" } },
})
