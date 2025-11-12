---@type LazyConfig
return {
    "ibhagwan/fzf-lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = function()
        local Position = {
            TopLeft = 1,
            Top = 2,
            TopRight = 3,
            Right = 4,
            BottomRight = 5,
            Bottom = 6,
            BottomLeft = 7,
            Left = 8,
        }

        local double_border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" }

        return {
            { "default-title" },
            number = false,
            -- fzf_bin = "sk",

            winopts = {
                border = function(_, m)
                    assert(m.type == "nvim" and m.name == "fzf")
                    if m.nwin == 1 then
                        return double_border
                    end

                    assert(type(m.layout) == "string")

                    local b = vim.deepcopy(double_border)

                    if m.layout == "down" then
                        b[Position.Bottom] = ""
                    elseif m.layout == "up" then
                        b[Position.Top] = ""
                    elseif m.layout == "left" then
                        b[Position.Left] = ""
                    else -- right
                        b[Position.Right] = ""
                    end

                    return b
                end,

                preview = {
                    scrollbar = "float",

                    border = function(_, m)
                        if m.type == "fzf" then
                            return double_border
                        end

                        assert(
                            m.type == "nvim"
                            and m.name == "prev"
                            and type(m.layout) == "string"
                        )

                        local b = vim.deepcopy(double_border)

                        if m.layout == "down" then
                            b[Position.TopLeft] = "╟"
                            b[Position.Top] = "─"
                            b[Position.TopRight] = "╢"
                        elseif m.layout == "up" then
                            b[Position.BottomRight] = "╢"
                            b[Position.Bottom] = "─"
                            b[Position.BottomLeft] = "╟"
                        elseif m.layout == "left" then
                            b[Position.TopRight] = "╤"
                            b[Position.Right] = "│"
                            b[Position.BottomRight] = "╧"
                        else -- right
                            b[Position.TopLeft] = "╤"
                            b[Position.Left] = "│"
                            b[Position.BottomLeft] = "╧"
                        end

                        return b
                    end,
                },
            },
        }
    end,
    keys = function()
        local fzf = require("fzf-lua")
        return {
            { "<leader>fr", fzf.resume,       desc = "Fzf: Resume" },

            { "<leader>ff", fzf.files,        desc = "Fzf: Files" },
            { "<leader>fb", fzf.buffers,      desc = "Fzf: Buffer" },

            { "<leader>fS", fzf.lgrep_curbuf, desc = "Fzf: Buffer grep new" },
            {
                "<leader>fs",
                function()
                    fzf.lgrep_curbuf({ resume = true })
                end,
                desc = "Fzf: Buffer grep cont."
            },

            { "<leader>fG", fzf.live_grep_native, desc = "Fzf: Global grep new" },
            {
                "<leader>fg",
                function()
                    fzf.live_grep_native({ resume = true })
                end,
                desc = "Fzf: Global grep cont."
            },

            { "<leader>fw", fzf.grep_cword,       desc = "Fzf: Grep w-textobject" },
            { "<leader>fW", fzf.grep_cWORD,       desc = "Fzf: Grep W-textobject" },
        }
    end,
    init = function()
        require("fzf-lua").register_ui_select()
    end,
}
