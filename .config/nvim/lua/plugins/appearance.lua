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
                    lualine_c = { 'filename', 'aerial' }
                }
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
            base16.setup()
            local load_from_shell = function()
                local res = base16.load_from_shell()
                if res then
                    vim.notify('Loaded base16 scheme from base16-shell: ' .. res, vim.log.levels.DEBUG)
                end
            end
            load_from_shell()
            vim.keymap.set('n', '<leader>bt', load_from_shell, {
                desc = 'Base16: Load colorscheme from base16-shell',
            })
            require("base16-live-reload").setup()
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
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local alpha = require('alpha')
            local handle = io.popen('fortune -s')
            local theta = require('alpha.themes.theta')
            if handle ~= nil then
                local fortune = handle:read("*a")
                handle:close()
                theta.header.val = fortune
            end
            alpha.setup(theta.config)
        end
    },
    {
        'https://github.com/chentoast/marks.nvim',
        config = function()
            require('marks').setup({
                default_mappings = true,
                builtin_marks = { ".", "<", ">", "^" },
                cyclic = true,
                force_write_shada = false,
                bookmark_0 = {
                    sign = '⚑',
                    hl = 'Todo',
                },
                -- mappings = {
                --     toggle = 'm',
                --     cycle = 'M',
                --     delete = 'd',
                --     next = ']',
                --     prev = '[',
                -- },
            })
        end
    }
}
