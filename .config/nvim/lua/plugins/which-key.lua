return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    lazy = false,
    init = function()
        vim.opt.timeout = true
        vim.opt.timeoutlen = 500
    end,
    opts = {
        spelling = {
            enabled = true,
        },
        window = {
            border = "single",
        },
    }
}
