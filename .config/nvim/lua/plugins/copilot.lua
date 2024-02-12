return {
    {
        'github/copilot.vim',
        cmd = 'Copilot',
        event = "InsertEnter",
        keys = {
            {"<leader>cp", ":Copilot panel<CR>", noremap = true, silent = true, desc = "Copilot panel"},
        },
    }
}
