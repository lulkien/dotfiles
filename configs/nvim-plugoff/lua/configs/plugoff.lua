local plugoff = require("plugoff")

local opts = {}

local success, plugins = pcall(require, "plugins")

if not success or not plugins then
	plugins = {}
end

plugoff.setup(plugins, opts)
