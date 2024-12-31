return {
    {
        -- https://github.com/stevearc/conform.nvim
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "gopls" }
            }
        }
    },
}
