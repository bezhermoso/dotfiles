return {
    {
        'echasnovski/mini.splitjoin',
        enabled = false,
        version = '*',
        config = function()
            require("mini.splitjoin").setup({
                mappings = {
                    toggle = "<leader>j",
                },
            })
        end,
    },
    {
        'Wansmer/treesj',
        keys = {
            {"<leader>j", function() require("treesj").toggle() end, desc = "Toggle split/join"},
        },
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('treesj').setup({
                use_default_keymaps = false,
            })
        end,
    }
}
