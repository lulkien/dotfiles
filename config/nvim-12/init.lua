--- Safely require a module, return nil on failure.
--- @param module string The module name to require.
--- @param silent? boolean If true, suppresses error messages.
--- @return any|nil loaded_module Returns the module if successful, nil otherwise.
local function safe_require(module, silent)
	local ok, loaded = pcall(require, module)
	if not ok then
		if not silent then
			print("Failed to require '" .. module .. "': " .. loaded)
		end
		return {}
	end
	return loaded
end

----------------------------------------------- CORE -----------------------------------------------

safe_require("core.options")
safe_require("core.keymaps")
safe_require("core.autocmds")

----------------------------------------------- PACK -----------------------------------------------

safe_require("core.pack")

----------------------------------------------- LSP -----------------------------------------------

safe_require("core.lsp")
