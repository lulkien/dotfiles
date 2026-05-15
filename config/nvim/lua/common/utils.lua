--- Safely require a module, print and return nil on failure.
--- @param module string The module name to require.
--- @param silent? boolean If true, suppresses error messages.
--- @return any|nil loaded_module Returns the module if successful, nil otherwise.
function safe_require(module, silent)
	local ok, mod = pcall(require, module)
	if not ok then
		if not silent then
			print("Failed to require: " .. module)
		end
		return nil
	end
	return mod
end
