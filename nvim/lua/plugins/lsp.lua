return {
    {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
        lazy = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = true,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

        },
        config = function()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {'gopls', 'phpactor', 'lua_ls'},
            })
            local on_attach = function ()
                vim.keymap.set('n', '<leader>mv', vim.lsp.buf.rename, {})
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
                vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            end
            local lspconfig = require('lspconfig')
            lspconfig.gopls.setup({
                on_attach = on_attach,
            })
            lspconfig.phpactor.setup({
                on_attach = on_attach,
            })
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {'vim'},
                        }
                    }
                }
            })
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
