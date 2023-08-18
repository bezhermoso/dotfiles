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
    },
    {
        "almo7aya/openingh.nvim",
        enabled = vim.fn.executable('gh') == 1,
        lazy = false,
        config = function()
            require('openingh').setup()
            -- for repository page
            vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>", { silent = true, noremap = true, desc = 'Open repo in Github' })

            -- for current file page
            vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>", { silent = true, noremap = true, desc = 'Open in Github' })
            vim.api.nvim_set_keymap("v", "<Leader>gf", ":OpenInGHFileLines <CR>", { silent = true, noremap = true, desc = 'Open it Github' })
        end
    }
}
