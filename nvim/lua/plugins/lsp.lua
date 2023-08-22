return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.api.nvim_command, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-calc' },
            { 'f3fora/cmp-spell' },
            { 'tamago324/cmp-zsh' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-emoji' },
            { 'andersevenrud/cmp-tmux' },
            { 'KadoBOT/cmp-plugins' },
            { 'dmitmel/cmp-cmdline-history' },
            { 'chrisgrieser/cmp-nerdfont' },
            {
                "bezhermoso/cmp-atuin",
                dev = true,
            },
            { "petertriho/cmp-git" },
            { "folke/neodev.nvim" }
        },
        config = function()
            -- Language Server Protocol (LSP) {{{
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'gopls',        -- Go
                    'intelephense', -- PHP
                    'lua_ls',       -- Lua
                    'phpactor',     -- PHP
                    'yamlls',       -- YAML
                },
            })
            require('neodev').setup({})
            local lsp_zero = require('lsp-zero').preset({})
            lsp_zero.on_attach(function(_, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
                vim.keymap.set('n', '<leader>mv', vim.lsp.buf.rename, {
                    desc = 'LSP: Rename',
                })
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
                    desc = 'LSP: Code Actions...',
                })
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
                    desc = 'LSP: Go to definition',
                })
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
                    desc = 'LSP: Go to implementation',
                })
                vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {
                    desc = 'LSP: Show usages'
                })
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
                    desc = 'LSP: Show tooltip'
                })
                vim.keymap.set('n', '<leader>==', vim.lsp.buf.format, {
                    desc = 'LSP: Format',
                })
                local open_line_diagnostic = function ()
                    vim.diagnostic.open_float(0, {scope = "line"})
                end
                vim.keymap.set('n', '<leader>e', open_line_diagnostic, {
                    desc = 'LSP: Line Diagnostics'
                })
            end)
            -- Make Lua language server understand Neovim API
            local lspconfig = require('lspconfig')

            -- Lua {{{
            lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())
            -- }}}
            --
            -- YAML {{{
            lspconfig.yamlls.setup({
                schemas = {
                    kubernetes = "*.yaml",
                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                },
            })
            -- }}}

            lsp_zero.setup({
                set_extra_mappings = true,
            })
            -- }}}

            -- COMPLETION {{{
            -- lsp-zero already sets up nvim-cmp for us, here we are simply
            -- setting more configuration e.g. adding sources.
            local cmp = require('cmp')
            -- require('atuin').setup()
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp',              priority = 1000 },
                    { name = 'luasnip',               priority = 750 },
                    { name = 'buffer',                priority = 500 },
                    { name = 'path',                  priority = 250 },
                    { name = 'nvm_lsp_signature_help' },
                    { name = 'calc' },
                    { name = 'spell' },
                    { name = 'zsh' },
                    { name = 'tmux' },
                    { name = 'emoji' },
                    { name = 'nerdfont' },
                    { name = 'plugins' },
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }
            })

            cmp.setup.cmdline({'/', '?'}, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    {
                        { name = 'path' }
                    },
                    {
                        { name = 'cmdline' }
                    }
                    -- {
                    --     { name = 'atuin', opts = { replace_trigger_chars = nil }}
                    -- }
                )
            })

            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources(
                    {
                        { name = 'git '}
                    },
                    {
                        { name = 'buffer' }
                    }
                )
            })

            cmp.setup.filetype({'bash', 'zsh', 'markdown'}, {
                sources = cmp.config.sources(
                    {
                        { name = 'git '}
                    },
                    {
                        { name = 'buffer' }
                    }
                    -- {
                    --     { name = 'atuin' },
                    -- }
                )
            })
            -- }}}
        end
    },
    {
        -- https://github.com/folke/trouble.nvim
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>E", ":TroubleToggle<CR>", desc = 'LSP: Toggle Trouble diagnostic pane' },
        },
        opts = {},
    },
    {
        'numToStr/Comment.nvim',
        event = 'BufEnter',
        config = function()
            require('Comment').setup()
        end
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {}
    },
}
