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
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
    },
    {
        'RRethy/nvim-base16',
        priority = 1000,
        dev = true,
        lazy = false,
        dependencies = {
            'rcarriga/nvim-notify',
        },
        config = function()
            local base16 = require('base16-colorscheme')
            base16.setup()
            local load_from_shell = function ()
                local res = base16.load_from_shell()
                if res then
                    vim.notify('Loaded base16 scheme from base16-shell: ' .. res, vim.log.levels.DEBUG)
                end
            end
            load_from_shell()

            vim.keymap.set('n', '<leader>bt', load_from_shell, {
                desc = 'Base16: Load colorscheme from base16-shell',
            })
        end
    },
    {
        'rcarriga/nvim-notify',
        lazy = false,
        priority = 1000,
        keys = {
            {"<leader>]", ":lua require('notify').dismiss()<CR>", desc = 'Dismiss notifications'},
        },
        config = function()
            local notify = require('notify')
            notify.setup({
                render = "compact",
            })
            vim.notify = notify
        end
    }
}
