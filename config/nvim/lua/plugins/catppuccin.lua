---@type LazyConfig
return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha",     -- latte, frappe, macchiato, mocha
        background = {
            light = "latte",
            dark = "mocha",
        },
        transparent_background = false,     -- disables setting the background color.
        show_end_of_buffer = false,         -- shows the '~' characters after the end of buffers
        term_colors = false,                -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false,                -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15,              -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,                  -- Force no italic
        no_bold = false,                    -- Force no bold
        no_underline = false,               -- Force no underline
        styles = {                          -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" },        -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            notify = true,
            treesitter = true,
            alpha = true,
            indent_blankline = {
                enabled = true,
                scope_color = "text",
                colored_indent_levels = false,
            },
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                    ok = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                    ok = { "underline" },
                },
                inlay_hints = {
                    background = true,
                },
            },
            which_key = false,
        },
    },
    init = function()
        vim.cmd.colorscheme("catppuccin")
    end,
}
