local ts = require("nvim-treesitter")
local ts_config = require("nvim-treesitter.config")

ts_config.setup({
	auto_install = true,
})

-- Install parser
local ensureInstalled = { "lua", "rust", "cpp", "c", "bash", "fish", "html", "css", "javascript" }

local alreadyInstalled = ts_config.get_installed()
local parsersToInstall = vim.iter(ensureInstalled)
	:filter(function(parser)
		return not vim.tbl_contains(alreadyInstalled, parser)
	end)
	:totable()

ts.install(parsersToInstall)

-- OnFileType
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		-- Enable treesitter highlighting and disable regex syntax
		pcall(vim.treesitter.start)
		-- Enable treesitter-based indentation
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- OnPackChanged
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" then
			vim.system({ "make" }, { cwd = ev.data.path })
		end
	end,
})
