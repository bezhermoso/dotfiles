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
        -- https://github.com/nvim-tree/nvim-web-devicons
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        -- https://github.com/RRethy/nvim-base16
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
        -- https://github.com/rcarriga/nvim-notify
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
    {
        'https://github.com/folke/zen-mode.nvim',
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
        -- https://github.com/goolord/alpha-nvim
        'goolord/alpha-nvim',
        dev = true,
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require('alpha')
            require('alpha.term')
            if block_hostnames[vim.fn.hostname()] then
                alpha.setup(require('plugins.alpha.block').alpha_config())
            else
                alpha.setup(require('plugins.alpha.tolkien').alpha_config())
            end
        end
    },
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
        -- https://github.com/luukvbaal/statuscol.nvim
        "luukvbaal/statuscol.nvim",
        config = function ()
            require("statuscol").setup({
                relculright = true,
            })
        end
    }
}
