return {
    {
        -- https://github.com/github/copilot.vim
        'github/copilot.vim',
        cmd = 'Copilot',
        lazy = false,
        config = function()
            vim.keymap.set('i', 'kj', 'copilot#Accept("kj")', {
                expr = true,
                silent = true,
                script = true,
                replace_keycodes = false,
            })
            vim.keymap.set('i', '<M-;>', 'copilot#Accept(";")', {
                expr = true,
                silent = true,
                script = true,
                replace_keycodes = false,
            })
            vim.g.copilot_no_tab_map = true
        end,
        keys = {
            { "<leader>cp", ":Copilot panel<CR>", noremap = true, silent = true, desc = "Copilot panel" },
        },
    },
    {
        'azorng/goose.nvim',
        config = function()
            require('goose').setup({})
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- See ./markdown.lua
            "MeanderingProgrammer/render-markdown.nvim",
        },
        keys = {
            { "<leader>tgg", function() require("goose.api").toggle() end,                 noremap = true, silent = true, desc = "[T]alk to [G]oose" },
            { "<leader>tgn", function() require("goose.api").open_input_new_session() end, noremap = true, silent = true, desc = "Goose: open input new session" },
            { "<leader>tgc", function() require("goose.api").close() end,                  noremap = true, silent = true, desc = "Goose: close" },
            { "<leader>tgq", function() require("goose.api").stop() end,                   noremap = true, silent = true, desc = "Goose: quit" },
            { "<leader>tgf", function() require("goose.api").select_session() end,         noremap = true, silent = true, desc = "Goose: select session" },
        }
    }
}
