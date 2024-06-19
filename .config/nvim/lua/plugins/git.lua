local git_installed = vim.fn.executable('git') == 1
local gh_installed = vim.fn.executable('gh') == 1
return {
    {
        -- https://github.com/tpope/vim-fugitive
        "tpope/vim-fugitive",
        enabled = git_installed,
        dependencies = {
            "tpope/vim-rhubarb",
        },
        cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "G", "GBrowse" },
        -- keys = {
        --     { "<leader>G", vim.cmd.G, desc = "Git status" }
        -- },
    },
    {
        -- https://github.com/lewis6991/gitsigns.nvim
        "lewis6991/gitsigns.nvim",
        enabled = git_installed,
        keys = {
            { "<leader>gB", ":Gitsigns blame_line<CR>", {
                desc = "Git: Show blame on current line",
            } },
            { "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {
                desc = "Git: Toggle inline blames",
            } },
            { "<leader>gp", ":Gitsigns preview_hunk<CR>", {
                desc = "Git: Preview hunk",
            } },
        },
        lazy = false,
        opts = {}
    },
    {
        -- https://github.com/Almo7aya/openingh.nvim
        "Almo7aya/openingh.nvim",
        enabled = gh_installed,
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
        -- https://github.com/sindrets/diffview.nvim
        "sindrets/diffview.nvim",
        enabled = git_installed,
        event = "VeryLazy",
        keys = {
            { "<leader>do", ":DiffviewOpen<CR>", desc = "Diff: Open" },
            { "<leader>dc", ":DiffviewClose<CR>", desc = "Diff: Close" },
        },
        opts = {},
    },
    {
        -- https://github.com/pwntester/octo.nvim
        "pwntester/octo.nvim",
        enabled = gh_installed,
        event = "VeryLazy",
        opts = {},
    },
    {
        -- https://github.com/NeogitOrg/neogit
        "NeogitOrg/neogit",
        enabled = git_installed,
        cmd = {"Neogit"},
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim", -- Diff integration
            "nvim-telescope/telescope.nvim", -- Will be used for pickers
        },
        keys = {
            { "<leader>G", function() require('neogit').open({ kind = "tab" }) end, desc = "Neogit: Git status (new tab)" },
            { "<leader>gs", function() require('neogit').open({ kind = "split" }) end, desc = "Neogit: Git status (split)" }
        },
        opts = {
            graph_style = "unicode",
            console_timeout = 10000, -- ms before the console is opened; increasing this because Git can be slow in monorepos
            -- Use fzf sorter
            telescope_sorter = function()
                return require("telescope").extensions.fzf.native_fzf_sorter()
            end,
        },
    },
}
