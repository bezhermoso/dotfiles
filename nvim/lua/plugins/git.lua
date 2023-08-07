return {
    {
        "tpope/vim-fugitive",
        enabled = vim.fn.executable('git') == 1,
        keys = {
            { "<leader>G", vim.cmd.G, desc = "Git status" }
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        enabled = vim.fn.executable('git') == 1,
        lazy = false,
        opts = {}
    }
}
