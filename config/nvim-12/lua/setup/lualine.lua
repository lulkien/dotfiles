local mode = {
	"mode",
	fmt = function(str)
		return " " .. str
		-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
	end,
}

local filename = {
	"filename",
	file_status = true, -- displays file status (readonly status, modified status)
	path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
}

local hide_in_width = function()
	return vim.fn.winwidth(0) > 100
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = {
		error = " ",
		warn = " ",
		info = " ",
		hint = " ",
	},
	colored = false,
	update_in_insert = false,
	always_visible = false,
	cond = hide_in_width,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

require("lualine").setup({
	options = {
		icons_enabled = true,
		-- Some useful glyphs:
		-- https://www.nerdfonts.com/cheat-sheet
		--          
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "neo-tree", "NvimTree", "qf" },
		always_divide_middle = true,
		theme = "catppuccin-mocha",
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { filename },
		lualine_c = { "branch" },
		lualine_x = {
			diagnostics,
			diff,
			{ "encoding", cond = hide_in_width },
			{ "filetype", cond = hide_in_width },
		},
		lualine_y = { "location" },
		lualine_z = { "progress" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { { "location", padding = 0 } },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "fugitive" },
})
