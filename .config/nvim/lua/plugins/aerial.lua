return {
    {
        "https://github.com/stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            layout = {
                min_width = 20,
            },
            autojump = true,
        },
        keys = {
            {"<leader>ss", "<cmd>AerialToggle!<CR>", desc = "Aerial: Toggle [(s)how (s)tructure]"},
        }
    }
}
