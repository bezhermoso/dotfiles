return {
    {
        "ggandor/leap.nvim",
        dependencies = {
            { "tpope/vim-repeat" }
        },
        config = function()
            require("leap").set_default_mappings()
        end
    }
}
