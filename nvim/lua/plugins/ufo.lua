return {
    "https://github.com/kevinhwang91/nvim-ufo",
    lazy = false,
    dependencies = {
        { "https://github.com/kevinhwang91/promise-async" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
        { "n", "zR", function() require('ufo').openAllFolds() end },
        { "n", "zM", function() require('ufo').closeAllFolds() end },
    },
    setup = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        require('ufo').setup({
            provider_selector = function ()
                return {'treesitter', 'indent'}
            end
        })
    end,
}
