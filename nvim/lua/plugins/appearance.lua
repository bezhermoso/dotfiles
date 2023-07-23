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
        config = function()
            local base16_adopt_shell_theme = function ()
            local themepath = vim.fn.expand('~/.vimrc_background')
                if vim.loop.fs_stat(themepath) then
                    print('Loading theme from ' .. themepath)
                    vim.cmd('source ' .. themepath)
                end
            end
            base16_adopt_shell_theme()

            vim.keymap.set('n', '<leader>bt', base16_adopt_shell_theme)
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            --  vim.cmd([[colorscheme catppuccin]])
        end
    },
}

