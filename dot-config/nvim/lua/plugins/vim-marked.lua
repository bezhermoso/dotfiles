return {
    -- https://github.com/itspriddle/vim-marked
    "itspriddle/vim-marked",
    ft = {"markdown", "mkd", "ghmarkdown", "vimwiki"},
    keys = {
        {"<leader>M", ":MarkedToggle!<CR>", desc = "Markdown: Open in Marked", silent = true}
    }
}
