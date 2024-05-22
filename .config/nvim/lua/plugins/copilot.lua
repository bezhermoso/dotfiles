return {
    {
        -- https://github.com/github/copilot.vim
        'github/copilot.vim',
        cmd = 'Copilot',
        lazy = false,
        config = function ()
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
            {"<leader>cp", ":Copilot panel<CR>", noremap = true, silent = true, desc = "Copilot panel"},
        },
    }
}
