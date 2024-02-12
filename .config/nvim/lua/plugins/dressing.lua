return {
    {
        'stevearc/dressing.nvim',
        opts = {
            select = {
                enable = false,
                backend = { 'telescope' }
            },
            input = {
                insert_only = false,
                start_in_insert = false,
                relative = "editor"
            },
            win_options = {
                sidescrolloff = 10,
            }
        },
    },
    {
        "gelguy/wilder.nvim",
        keys = { ":", "/", "?" },
        config = function()
            local wilder = require("wilder")
            wilder.setup({
                modes = { ":", "/", "?" },
                next_key = "<C-n>",
                previous_key = "<C-p>",
            })
            -- Enable fuzzy matching for commands and buffers
            wilder.set_option("pipeline", {
                wilder.branch(
                    wilder.cmdline_pipeline({
                        fuzzy = 1,
                    }),
                    wilder.vim_search_pipeline({
                        fuzzy = 1,
                    })
                ),
            })

            wilder.set_option(
                "renderer",
                wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
                    highlighter = wilder.basic_highlighter(),
                    highlights = {
                        default = "Default",
                        border = "String",
                        selected = "StatusLine",
                    },
                    pumblend = 5,
                    min_width = "100%",
                    min_height = "25%",
                    max_height = "25%",
                    border = "rounded" or {
                        -- Top border
                        "─", "─", "─",
                        -- Left
                        "",
                        -- Right
                        "",
                        -- Bottom border
                        "-", "-", "-",
                    },
                    left = { " ", wilder.popupmenu_devicons() },
                    right = { " ", wilder.popupmenu_scrollbar() },
                }))
            )
        end,
        event = "CmdLineEnter",
        build = ":UpdateRemotePlugins"
    }
}
