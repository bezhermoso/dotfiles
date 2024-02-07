return {
    {
        "tpope/vim-fugitive",
        enabled = vim.fn.executable('git') == 1,
        dependencies = {
            "tpope/vim-rhubarb",
        },
        cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "G", "GBrowse" },
        keys = {
            { "<leader>G", vim.cmd.G, desc = "Git status" }
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        enabled = vim.fn.executable('git') == 1,
        keys = {
            { "<leader>gB", ":Gitsigns blame_line<CR>", {
                desc = "Git: Show blame on current line",
            }},
            { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {
                desc = "Git: Toggle inline blames",
            }},
            { "<leader>gp", ":Gitsigns preview_hunk<CR>", {
                desc = "Git: Preview hunk",
            }},
        },
        lazy = false,
        opts = {}
    },
    {
        "Almo7aya/openingh.nvim",
        enabled = vim.fn.executable('gh') == 1,
        lazy = false,
        config = function()
            require('openingh').setup()
            -- for repository page
            vim.api.nvim_set_keymap("n", "<Leader>gr", ":OpenInGHRepo <CR>",
                { silent = true, noremap = true, desc = 'Open repo in Github' })

            -- for current file page
            vim.api.nvim_set_keymap("n", "<Leader>gf", ":OpenInGHFile <CR>",
                { silent = true, noremap = true, desc = 'Open in Github' })
            vim.api.nvim_set_keymap("v", "<Leader>gf", ":OpenInGHFileLines <CR>",
                { silent = true, noremap = true, desc = 'Open in Github' })
        end
    },
    {
        "sindrets/diffview.nvim",
        enabled = vim.fn.executable('git') == 1,
        event = "VeryLazy",
        opts = {},
    },
    {
        "pwntester/octo.nvim",
        enabled = vim.fn.executable('gh') == 1,
        event = "VeryLazy",
        opts = {},
    }
}
