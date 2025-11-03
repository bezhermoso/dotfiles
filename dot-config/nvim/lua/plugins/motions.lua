return {
    {
        "ggandor/leap.nvim",
        dependencies = {
            { "tpope/vim-repeat" }
        },
        keys = {
            { "s", "<Plug>(leap)", desc = "Leap", silent = true, mode = {"n", "x", "o"} },
            { "S", "<Plug>(leap-from-window)", desc = "Leap from window", silent = true, mode = {"n"} },
        },
    }
}
