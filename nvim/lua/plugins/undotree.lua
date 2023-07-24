return {
    "mbbill/undotree",
    keys = {
        {"<leader>u", vim.cmd.UndotreeToggle, desc = "UndoTree: Toggle"},
    },
    init = function()
        vim.opt.undofile = true
    end
}
