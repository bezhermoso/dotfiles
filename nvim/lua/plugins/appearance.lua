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
            local base16_adopt_shell_theme = function()
                local fn = vim.fn
                local cmd = vim.cmd
                local set_theme_path = "$HOME/.config/tinted-theming/set_theme.lua"
                local is_set_theme_file_readable = fn.filereadable(fn.expand(set_theme_path)) == 1 and true or false
                if is_set_theme_file_readable then
                    cmd("let base16colorspace=256")
                    cmd("source " .. set_theme_path)
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
