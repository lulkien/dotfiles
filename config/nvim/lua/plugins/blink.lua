---@type LazyConfig
return {
    "saghen/blink.cmp",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
        },
        "nvim-tree/nvim-web-devicons",
        "onsails/lspkind.nvim",
    },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            ["<C-space>"] = {
                "show",
                "show_documentation",
                "hide_documentation",
            },
            ["<C-e>"] = { "hide", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-y>"] = { "accept", "fallback" },

            ["<Tab>"] = { "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "fallback" },

            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
            ["<C-n>"] = { "select_next", "fallback_to_mappings" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },

        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },

        completion = {
            menu = {
                border = "rounded",
                draw = {
                    columns = {
                        { "label", "label_description", gap = 1 },
                        { "kind_icon", "kind", "source_name", gap = 1 },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local lspkind = require("lspkind")
                                local icon = ctx.kind_icon
                                if
                                    vim.tbl_contains(
                                        { "Path" },
                                        ctx.source_name
                                    )
                                then
                                    local dev_icon, _ =
                                        require("nvim-web-devicons").get_icon(
                                            ctx.label
                                        )
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = lspkind.symbolic(ctx.kind, {
                                        mode = "symbol",
                                    })
                                end
                                return icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if
                                    vim.tbl_contains(
                                        { "Path" },
                                        ctx.source_name
                                    )
                                then
                                    local dev_icon, dev_hl =
                                        require("nvim-web-devicons").get_icon(
                                            ctx.label
                                        )
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        },
                    },
                    treesitter = { "lsp" },
                },
            },
            ghost_text = {
                enabled = false,
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 300,
            },
        },

        signature = { enabled = true },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
