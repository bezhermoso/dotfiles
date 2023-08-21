return {
    'stevearc/dressing.nvim',
    opts = {
        select = {
            enable = false,
            backend = {'telescope'}
        },
        input = {
            insert_only = false,
            start_in_insert = false,
            relative = "editor"
        },
        win_options = {
            sidescrolloff = 10,
        }
    },
}
