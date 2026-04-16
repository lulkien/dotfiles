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
local fzf = require("fzf-lua")

fzf.setup({
	{ "default-title" },
	number = false,

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

-- Keybinding
vim.keymap.set("n", "<leader>fr", fzf.resume, { noremap = true, desc = "Fzf: Resume" })

vim.keymap.set("n", "<leader>ff", fzf.files, { noremap = true, desc = "Fzf: Files" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { noremap = true, desc = "Fzf: Buffer" })

vim.keymap.set("n", "<leader>fS", fzf.lgrep_curbuf, { noremap = true, desc = "Fzf: Buffer grep new" })
vim.keymap.set("n", "<leader>fs", function()
	fzf.lgrep_curbuf({ resume = true })
end, { noremap = true, desc = "Fzf: Buffer grep cont." })

vim.keymap.set("n", "<leader>fG", fzf.live_grep_native, { noremap = true, desc = "Fzf: Global grep new" })
vim.keymap.set("n", "<leader>fg", function()
	fzf.live_grep_native({ resume = true })
end, { noremap = true, desc = "Fzf: Global grep cont." })

vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { noremap = true, desc = "Fzf: Grep w-textobject" })
vim.keymap.set("n", "<leader>fW", fzf.grep_cWORD, { noremap = true, desc = "Fzf: Grep W-textobject" })

-- OnVimEnter
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		fzf.register_ui_select()
	end,
})
