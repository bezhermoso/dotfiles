return {
    "mbbill/undotree",
    keys = {
        {"<leader>u", vim.cmd.UndotreeToggle, desc = "UndoTree: Toggle"},
    },
    init = function()
        -- Enable persistent undo
        vim.opt.undofile = true
        -- undotree configuration:
        vim.g.undotree_WindowLayout = 2
    end
}
