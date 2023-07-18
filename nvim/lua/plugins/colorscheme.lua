
return {
    {
        'nvim-tree/nvim-web-devicons',
        lazy = true,
    },
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme base16-gruvbox-dark-hard]])
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

