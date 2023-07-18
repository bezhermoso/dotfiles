
return {
    "nvim-tree/nvim-tree.lua",
    keys = {
        {"<leader>n", ":NvimTreeFindFileToggle<CR>"}
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                float = {
                    enable = true,
                    open_win_config = {
                        height = 100,
                        border = "shadow",
                        row = 0,
                        col = 0,
                    }
                }
            }
        })
    end,
}

