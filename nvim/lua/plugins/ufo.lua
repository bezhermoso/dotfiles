
-- Apparently there are filetypes whose LSP does not support folding. We can fallback to Treesitter instead.
-- Source: https://github.com/chrisgrieser/.config/blob/a3c5be040b46f7dc43e5e10c15c807fa505bcb10/nvim/lua/plugins/folding-plugins.lua#L65-L72
local treesitter_based_folding_filetypes = {
    "markdown",
    "sh",
    "css",
    "html",
    "python",
}
return {
    "https://github.com/kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
        { "https://github.com/kevinhwang91/promise-async" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
        { "zR", function() require('ufo').openAllFolds() end },
        { "zM", function() require('ufo').closeAllFolds() end },
        require("core.ufo").lazy_mapping(),
    },
    init = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        require('ufo').setup({
            close_fold_kinds = {"comment", "imports"},
            provider_selector = function (_, ftype, _)
                if vim.tbl_contains(treesitter_based_folding_filetypes, ftype) then
                    return {'treesitter', 'indent'}
                end
                return {'lsp', 'indent'}
            end
        })
    end,
}
