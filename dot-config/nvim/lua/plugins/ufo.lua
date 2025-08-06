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
    -- https://github.com/kevinhwang91/nvim-ufo
    "kevinhwang91/nvim-ufo",
    event = "BufRead",
    dependencies = {
        { "https://github.com/kevinhwang91/promise-async" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
        { "zR", function() require('ufo').openAllFolds() end,           desc = "Folds: open all" },
        { "zM", function() require('ufo').closeAllFolds() end,          desc = "Folds: close all" },
        { "K",  function() require("core.ufo").peek_or_lsp_hover() end, desc = "LSP/Folding: LSP lookup or preview folded range" },
    },
    init = function()
        vim.o.foldcolumn = "0" -- Hides the fold-column. Set to "1" to show 1-char width fold chars.
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    config = function()
        require("ufo").setup({
            close_fold_kinds_for_ft = {
                php = { "comment", "imports" },
            },
            provider_selector = function(_, ftype, _)
                if vim.tbl_contains(treesitter_based_folding_filetypes, ftype) then
                    return { "treesitter", "indent" }
                end
                return { "lsp", "indent" }
            end
        })
    end,
}
