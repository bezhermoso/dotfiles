
return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd([[colorscheme catppuccin]])
        end
    }
}

