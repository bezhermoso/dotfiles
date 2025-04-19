local block_hostnames = {
    ["balerion.local"] = true,
    ["block-03.local"] = true
}

return {
    {
        -- https://github.com/nvim-lualine/lualine.nvim
        'nvim-lualine/lualine.nvim',
        lazy = false,
        dependencies = {
            { "folke/todo-comments.nvim" },
            { "bezhermoso/todos-lualine.nvim", dev = true },
            { "stevearc/aerial.nvim" }
        },
        config = function ()
            -- TODO: Configure colors
            -- local todos_component = require("todos-lualine").component({})
            require('lualine').setup({
                options = {
                    theme = 'base16',
                    section_separators = '',
                    component_separators = '',
                },
                sections = {
                    -- lualine_b = { 'branch', 'diff', 'diagnostics', todos_component },
                    lualine_c = { 'filename', 'aerial' },
                },
            })
        end,
    },
    {
        -- https://github.com/RRethy/nvim-base16
        'RRethy/nvim-base16',
        enabled = false,
        priority = 5000,
        lazy = false,
        dependencies = {
            { 'rcarriga/nvim-notify' },
            -- {
            --     "bezhermoso/base16-live-reload.nvim",
            --     dev = true,
            -- },
            { 'rktjmp/fwatch.nvim' },
        },
        config = function()
            local base16 = require('base16-colorscheme')
            local base16_live_reload = require("base16-live-reload")

            local set_line_number_hls = function ()
                local colors = base16.colors
                base16.highlight.CursorLineNr = { guifg = colors.base0A, ctermfg = colors.cterm0A, fg = colors.base0A, gui = "bold" }
                base16.highlight.LineNr = { guifg = colors.base02, ctermfg = colors.cterm02, fg = colors.base02 }
            end

            base16.setup()
            base16_live_reload.setup()
            -- set_line_number_hls()

            vim.api.nvim_create_autocmd("User", {
                pattern = "TintedColorsPost",
                callback = function()
                    set_line_number_hls()
                end,
            })
        end
    },
    {
        -- https://github.com/tinted-theming/tinted-nvim
        'tinted-theming/tinted-nvim',
        enabled = true,
        priority = 5000,
        lazy = false,
        dev = true,
        dependencies = {
            { 'rcarriga/nvim-notify' },
            -- {
            --     "bezhermoso/base16-live-reload.nvim",
            --     dev = true,
            -- },
            { 'rktjmp/fwatch.nvim' },
        },
        config = function()
            local base16 = require('tinted-colorscheme')

            local set_line_number_hls = function ()
                local colors = base16.colors
                base16.highlight.CursorLineNr = { guifg = colors.base0A, ctermfg = colors.cterm0A, fg = colors.base0A, gui = "bold" }
                base16.highlight.LineNr = { guifg = colors.base02, ctermfg = colors.cterm02, fg = colors.base02 }
            end

            base16.setup("", {
                supports = {
                    live_reload = true
                }
            })
            -- set_line_number_hls()

            vim.api.nvim_create_autocmd("User", {
                pattern = "Base16ReloadPost",
                callback = function()
                    set_line_number_hls()
                end,
            })

            -- vim.keymap.set('n', '<leader>bt', base16_live_reload.reload, {
            --     desc = 'Base16: Load colorscheme from base16-shell',
            -- })
        end
    },
    {
        -- https://github.com/rcarriga/nvim-notify
        'rcarriga/nvim-notify',
        lazy = false,
        priority = 1000,
        keys = {
            { "<leader>]", ":lua require('notify').dismiss()<CR>", desc = 'Dismiss notifications' },
        },
        config = function()
            local notify = require('notify')
            ---@diagnostic disable-next-line: missing-fields
            notify.setup({
                render = "minimal",
            })
            vim.notify = notify
        end
    },
    {
        -- https://github.com/lukas-reineke/indent-blankline.nvim
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            indent = {
                --highlight = {'CursorColumn', 'Whitespace'},
                -- char = '',
                -- tab_char = '⇥',
            },
            whitespace = {
                --highlight = {'CursorColumn', 'Whitespace'},
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        },
    },
    -- {
    --     -- https://github.com/goolord/alpha-nvim
    --     'goolord/alpha-nvim',
    --     dev = true,
    --     dependencies = { 'nvim-tree/nvim-web-devicons' },
    --     config = function()
    --         local alpha = require('alpha')
    --         require('alpha.term')
    --         if block_hostnames[vim.fn.hostname()] then
    --             alpha.setup(require('plugins.alpha.block').alpha_config())
    --         else
    --             alpha.setup(require('plugins.alpha.tolkien').alpha_config())
    --         end
    --     end
    -- },
    {
        -- https://github.com/chentoast/marks.nvim
        'chentoast/marks.nvim',
        config = function()
            require('marks').setup({
                default_mappings = true,
                builtin_marks = {},
                cyclic = true,
                force_write_shada = false,
                bookmark_0 = {
                    sign = '⚑',
                    hl = 'Todo',
                },
                excluded_filetypes = { 'help', 'dashboard', 'dressing', 'DressingSelect', 'neo-tree' },
                -- mappings = {
                --     toggle = 'm',
                --     cycle = 'M',
                --     delete = 'd',
                --     next = ']',
                --     prev = '[',
                -- },
            })
        end
    },
    {
        -- https://github.com/stevearc/dressing.nvim
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
        -- https://github.com/gelguy/wilder.nvim
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
    },
    {
        -- https://github.com/j-hui/fidget.nvim
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {}
    },
    {
        -- https://github.com/3rd/image.nvim
        "3rd/image.nvim",
        dependencies = {
            {"luarocks.nvim"},
        },
        config = function()
            require("image").setup({
                backend = "ueberzug",
            })
        end
    },
    {
        -- https://github.com/luukvbaal/statuscol.nvim
        "luukvbaal/statuscol.nvim",
        config = function ()
            require("statuscol").setup({
                relculright = true,
            })
        end
    },
    {
        -- https://github.com/nvim-tree/nvim-web-devicons
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        'https://github.com/folke/zen-mode.nvim',
        opts = {}
    },
    {
        'brenoprata10/nvim-highlight-colors',
        opts = {}
    }
}
