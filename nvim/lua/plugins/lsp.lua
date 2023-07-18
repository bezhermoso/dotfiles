return {
    {
        'neovim/nvim-lspconfig',
        config = function()
            lspconfig = require('lspconfig')
            lspconfig.gopls.setup({})
            lspconfig.phpactor.setup({})
        end
    },
    {
        "ms-jpq/coq_nvim",
        branch = "coq",
        dependencies = {
            {
                "ms-jpq/coq.artifacts",
                branch = "artifacts",
            },
            {
                "neovim/nvim-lspconfig",
            }
            --{
            --    "ms-jpq/coc.thirdparty",
            --    branch = "3p"
            --}
        },
        lazy = false,
        build = ":COQdeps",
        init = function()
            vim.g.coq_settings = {
                auto_start = true
            }
        end,
        config = function()
            require('coq')
        end
    }
}
