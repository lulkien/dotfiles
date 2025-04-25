local wezterm = require("wezterm")
local action = wezterm.action

local config = {}
local keymap = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

keymap = {
	{
		key = "Backspace",
		mods = "SHIFT",
		action = action.SendKey({ key = "h", mods = "CTRL" }),
	},
	{
		key = "c",
		mods = "CTRL",
		action = action.SendKey({ key = "c", mods = "CTRL" }),
	},
	{
		key = "v",
		mods = "CTRL",
		action = action.SendKey({ key = "v", mods = "CTRL" }),
	},
	{
		key = "c",
		mods = "CTRL|SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(action.CopyTo("Clipboard"), pane)
			window:perform_action(action.ClearSelection, pane)
		end),
	},
	{
		key = "v",
		mods = "CTRL|SHIFT",
		action = action.PasteFrom("Clipboard"),
	},
	{
		key = "/",
		mods = "LEADER",
		action = action.Search({ CaseInSensitiveString = "" }),
	},
	--SCROLLINGS
	{
		key = "u",
		mods = "LEADER",
		action = action.ScrollByPage(-0.5),
	},
	{
		key = "d",
		mods = "LEADER",
		action = action.ScrollByPage(0.5),
	},
	{
		key = "b",
		mods = "LEADER",
		action = action.ScrollByPage(-1),
	},
	{
		key = "f",
		mods = "LEADER",
		action = action.ScrollByPage(1),
	},
	-- PANES
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = action.SplitHorizontal({ args = config.default_prog }),
	},
	{
		key = '"',
		mods = "LEADER|SHIFT",
		action = action.SplitVertical({ args = config.default_prog }),
	},
	{
		key = "q",
		mods = "LEADER",
		action = action.PaneSelect({
			alphabet = "123456789",
			mode = "Activate",
		}),
	},
	{
		key = "h",
		mods = "LEADER",
		action = action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = action.ActivatePaneDirection("Down"),
	},
	{
		key = "r",
		mods = "LEADER",
		action = action.RotatePanes("Clockwise"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- TABS
	{
		key = "c",
		mods = "LEADER",
		action = action.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "n",
		mods = "LEADER",
		action = action.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = action.ActivateTabRelative(-1),
	},
	{
		key = "&",
		mods = "LEADER|SHIFT",
		action = action.CloseCurrentTab({ confirm = false }),
	},
}

config = {
	default_prog = { "pwsh.exe", "-NoLogo" },
	window_background_opacity = 0.8,
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("CodeNewRoman Nerd Font Mono"),
	use_fancy_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	audible_bell = "Disabled",
	tab_max_width = 20,
	tab_bar_at_bottom = true,
	check_for_updates = false,
	animation_fps = 1,
	max_fps = 30,
	disable_default_key_bindings = true,
	leader = { key = "b", mods = "CTRL" },
	keys = keymap,
}

return config
