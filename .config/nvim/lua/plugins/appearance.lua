local block_hostnames = {
    ["balerion.local"] = true,
    ["block-03.local"] = true
}

return {
    {
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
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        'RRethy/nvim-base16',
        priority = 1000,
        lazy = false,
        dependencies = {
            { 'rcarriga/nvim-notify' },
            {
                "bezhermoso/base16-live-reload.nvim",
                dev = true,
            },
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
                pattern = "Base16ReloadPost",
                callback = function()
                    set_line_number_hls()
                end,
            })

            vim.keymap.set('n', '<leader>bt', base16_live_reload.reload, {
                desc = 'Base16: Load colorscheme from base16-shell',
            })

        end
    },
    {
        'rcarriga/nvim-notify',
        lazy = false,
        priority = 1000,
        keys = {
            { "<leader>]", ":lua require('notify').dismiss()<CR>", desc = 'Dismiss notifications' },
        },
        config = function()
            local notify = require('notify')
            notify.setup({
                render = "minimal",
            })
            vim.notify = notify
        end
    },
    {
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
    {
        'https://github.com/folke/zen-mode.nvim',
        opts = {}
    },
    {
        "https://github.com/3rd/image.nvim",
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
        'goolord/alpha-nvim',
        dev = true,
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require('alpha')
            require('alpha.term')
            local theta = require('alpha.themes.theta')

            if vim.fn.executable("fortune") == 1
                and vim.fn.executable("boxes") == 1
                and vim.fn.executable("lolcrab") == 1
                and block_hostnames[vim.fn.hostname()]
            then
                theta.header.type = "group"
                theta.header.val = {
                    {
                        type = "terminal",
                        command = "paste ~/.dotfiles/ascii/block-logo-ascii.txt =(echo; echo; echo; echo; fortune -s dune dune-messiah | fold -w 50 -s | boxes -d java-cmt -p l2 | lolcrab --custom '\\#FFB89C' '\\#FF9261' '\\#FF4F00' '\\#8FF8EC' '\\#2ED7C8' '\\#13BBAF')",
                        width = 100,
                        height = 17,
                        opts = {
                            position = "center",
                            redraw = true,
                            window_config = {},
                        },
                    },
                }
            else
                theta.header.type = "group"
                theta.header.val = {
                    {
                        type = "terminal",
                        -- command = "neowofetch --ascii ~/.dotfiles/ascii/block-logo-ascii.txt --gap 6 --disable de wm packages kernel uptime resolution cols term_font --colors 11 8 8 8 8 7",
                        command = "paste ~/.dotfiles/ascii/one-ring.txt",
                        width = 50,
                        height = 18,
                        opts = {
                            position = "center",
                            redraw = true,
                            window_config = {},
                        },
                    },
                }
                -- theta.header.val = {
                --     [[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣶⣶⣄⠀⢠⣄⡀⠀⠀⠀⠀]],
                --     [[⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⡿⠛⢻⣿⣿⣿⠀⢀⣿⣿⣦⡀⠀⠀]],
                --     [[⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⠋⠉⠁⠀⣸⣿⣿⡏⠀⢸⣿⣿⣿⣷⡄⠀]],
                --     [[⠀⠀⠀⠀⢀⣾⣿⣿⠋⠁⠉⠀⣰⣶⣾⣿⡿⠟⠀⢠⣿⣿⣿⣿⣿⣿⡄]],
                --     [[⠀⠀⠀⣴⣿⣿⠟⠛⠀⠀⣿⣿⣿⡿⠛⠉⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⡇]],
                --     [[⠀⢀⣾⣿⣿⠿⠀⠀⣶⣾⣿⡿⠋⠀⠀⠀⠀⣰⣿⣿⡟⠉⢻⣿⣿⣿⠇]],
                --     [[⠀⣾⣿⡏⠀⢀⣀⣴⣿⡿⠋⠀⠀⠀⠀⣠⣾⣿⣿⠋⠁⠀⢀⣿⣿⡟⠀]],
                --     [[⢸⣿⣿⣧⣀⣼⣿⣿⡟⠁⠀⠀⠀⣠⣾⣿⣿⠛⠛⠀⠀⣾⣿⣿⡟⠀⠀]],
                --     [[⠸⣿⣿⣿⣿⣿⡿⠏⠀⠀⢀⣠⣾⣿⡿⠿⠿⠀⢠⣤⣾⣿⣿⠟⠀⠀⠀]],
                --     [[⠀⠈⠉⠉⠁⠀⢀⣀⣤⣾⣿⣿⠿⠿⠃⠀⣀⣠⣾⣿⣿⡿⠃⠀⠀⠀⠀]],
                --     [[⠀⠳⣶⣶⣶⣿⣿⣿⣿⣿⣿⣏⠀⢀⣀⣠⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀]],
                --     [[⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀]],
                --     [[⠀⠀⠀⠀⠙⠻⢿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                --     [[⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
                -- }
            end
            alpha.setup(theta.config)
        end
    },
    {
        'https://github.com/chentoast/marks.nvim',
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
        -- https://github.com/luukvbaal/statuscol.nvim
        "luukvbaal/statuscol.nvim",
        config = function ()
            require("statuscol").setup({
                relculright = true,
            })
        end
    }
}
