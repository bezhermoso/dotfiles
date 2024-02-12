return {
    'itspriddle/vim-marked',
    ft = {'markdown', 'mkd', 'ghmarkdown', 'vimwiki'},
    keys = {
        {"<leader>M", ":MarkedToggle!<CR>", desc = 'Markdown: Open in Marked', silent = true}
    }
}
