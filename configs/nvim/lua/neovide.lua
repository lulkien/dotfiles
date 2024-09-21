if vim.g.neovide then
	vim.o.linespace = 0

	vim.g.neovide_scale_factor = 1.0

	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0.5

	vim.g.neovide_padding_top = 10
	vim.g.neovide_padding_bottom = 10
	vim.g.neovide_padding_right = 10
	vim.g.neovide_padding_left = 10

	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	vim.g.neovide_floating_shadow = true
	vim.g.neovide_floating_z_height = 10
	vim.g.neovide_light_angle_degrees = 45
	vim.g.neovide_light_radius = 5

	vim.g.neovide_transparency = 0.9

	vim.g.neovide_position_animation_length = 0.15

	vim.g.neovide_scroll_animation_length = 0.3

	vim.g.neovide_scroll_animation_far_lines = 1

	vim.g.neovide_hide_mouse_when_typing = true

	vim.g.neovide_underline_stroke_scale = 1.0

	vim.g.neovide_theme = "dark"

	vim.g.neovide_refresh_rate = 120

	vim.g.neovide_refresh_rate_idle = 5

	vim.g.neovide_cursor_animation_length = 0.08

	vim.g.neovide_cursor_trail_size = 0.4

	vim.g.neovide_cursor_animate_in_insert_mode = true

	vim.g.neovide_cursor_unfocused_outline_width = 0.125

	vim.g.neovide_cursor_smooth_blink = true

	vim.g.neovide_cursor_vfx_mode = ""

	vim.keymap.set("n", "<C-S-v>", '"+p')
	vim.keymap.set("v", "<C-S-v>", '"+p')
	vim.keymap.set("c", "<C-S-v>", "<C-R>+")
	vim.keymap.set("i", "<C-S-v>", '<ESC>"+pi')
end
