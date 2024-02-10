
return {
    "https://github.com/kevinhwang91/nvim-ufo",
    lazy = false,
    dependencies = {
        { "https://github.com/kevinhwang91/promise-async" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
        { "zR", function() require('ufo').openAllFolds() end },
        { "zM", function() require('ufo').closeAllFolds() end },
    },
    init = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        require('ufo').setup({
            provider_selector = function (_, ftype, _)
                return {'lsp', 'indent'}
            end
        })
    end,
}
