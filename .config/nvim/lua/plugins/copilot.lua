return {
    {
        'github/copilot.vim',
        cmd = 'Copilot',
        lazy = false,
        config = function ()
            vim.g.copilot_no_tab_map = true
        end,
        keys = {
            {"<leader>cp", ":Copilot panel<CR>", noremap = true, silent = true, desc = "Copilot panel"},
        },
    }
}
