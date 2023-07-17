return {
   -- {
   --     'nvim-lua/plenary.nvim'
   -- },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    }
                }
            }
        }
    }
}
