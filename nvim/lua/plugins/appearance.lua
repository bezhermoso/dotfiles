return {
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        opts = {
            options = {
                theme = 'base16',
                section_separators = '',
                component_separators = '',
            },
        },
    },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        'RRethy/nvim-base16',
        priority = 1000,
        lazy = false,
        dev = true,
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
}
