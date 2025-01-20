vim.g.mapleader = " "

-- Bootstrap Packoff
local plugoff_path = vim.fn.stdpath("data") .. "/plugoff/plugoff.nvim"

if not vim.loop.fs_stat(plugoff_path) then
	-- Bootstrap plugoff

	-- For development
	local repo = "git@github.com:lulkien/plugoff.nvim.git"

	-- For normal user
	-- local repo = "https://github.com/lulkien/plugoff.nvim.git"

	local result = vim.system({
		"git",
		"clone",
		repo,
		"--depth=1",
		"--branch=master",
		plugoff_path,
	}):wait()

	if result.code ~= 0 then
		print("git: " .. result.stderr)
	end
end

vim.opt.rtp:prepend(plugoff_path)

-- Load plugoff
require("configs.plugoff")

require("options")
require("autocmds")

vim.schedule(function()
	require("mappings")
end)
