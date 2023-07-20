
return {
    {
        'nvim-lualine/lualine.nvim',
        lazy = false,
        opts = {
            options = {
                theme = 'gruvbox',
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
        config = function()
            local themepath = vim.fn.expand('~/.vimrc_background')
            if vim.loop.fs_stat(themepath) then
                print('Loading theme from ' .. themepath)
            else
                vim.cmd('colorscheme base16-gruvbox-' .. vim.o.background .. 'hard')
            end
        end
    },
    {
        'RRethy/nvim-base16',
        priority = 1000,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            --  vim.cmd([[colorscheme catppuccin]])
        end
    }
}

