local copilot_opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
}

return {
    {
        -- https://github.com/VonHeikemen/lsp-zero.nvim
        "VonHeikemen/lsp-zero.nvim",
        branch = 'v3.x',
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
            -- Debugging
            { 'mfussenegger/nvim-dap' },
            { 'jay-babu/mason-nvim-dap.nvim' },
            { 'rcarriga/nvim-dap-ui' },
            { 'nvim-neotest/nvim-nio' },
            { 'theHamsta/nvim-dap-virtual-text' },
            -- Debugging: Go
            { 'leoluz/nvim-dap-go' },
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
            { "folke/neoconf.nvim" },
            { "folke/lazydev.nvim" },
            { 'zbirenbaum/copilot-cmp' },
            { "folke/lazydev.nvim" },
            -- Yank-ring
            { 'gbprod/yanky.nvim' },
            { 'chrisgrieser/cmp_yanky' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.on_attach(function(_, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
                vim.keymap.set('n', '<leader>mv', vim.lsp.buf.rename, {
                    desc = 'LSP: Rename',
                })
                vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {
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

                vim.keymap.set('n', 'K', require("core.ufo").peek_or_lsp_hover, {
                    desc = 'LSP/Folding: LSP lookup or preview folded range',
                })

                vim.keymap.set('n', '<leader>==', vim.lsp.buf.format, {
                    desc = 'LSP: Format',
                })
                local open_line_diagnostic = function()
                    -- vim.diagnostic.open_float(0, { scope = "line" })
                    vim.diagnostic.open_float({ scope = "line" })
                end
                vim.keymap.set('n', '<leader>e', open_line_diagnostic, {
                    desc = 'LSP: Line Diagnostics'
                })
            end)
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
            lsp_zero.set_server_config({
                capabilities = capabilities
            })

            require('neoconf').setup()
            -- Configure Lua LSP to understand Neovim plugin structures, etc.
            -- require('lazydev').setup()
            require('mason').setup({
                ui = {
                    border = "rounded",
                },
            })
            require('mason-lspconfig').setup({
                ensure_installed = {
                    -- Go
                    'gopls',
                    -- JSON
                    'jsonls',
                    -- PHP
                    'phpactor',
                    -- Lua
                    'lua_ls',
                    -- YAML
                    'yamlls',
                    -- Protobuf
                    'bufls',
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        -- Make Lua language server understand Neovim API
                        require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls({
                            settings = {
                                cmd = {"lua-language-server", "--log-level=trace"},
                            },
                        }))
                    end,
                    yamlls = function()
                        require('lspconfig').yamlls.setup({
                            settings = {
                                yaml = {
                                    schemas = {
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
                                        ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.son"] = "*flow*.{yml,yaml}",
                                        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                                        kubernetes = "ccd-*/**/*.yaml.template",
                                    },
                                    customTags = {
                                        "!secret sequence",
                                        "!Secret sequence",
                                    },
                                },
                            },
                        })
                    end,
                }
            })

            -- COMPLETION {{{
            -- lsp-zero already sets up nvim-cmp for us, here we are simply
            -- setting more configuration e.g. adding sources.
            local cmp = require('cmp')
            local cmp_mappings = require("plugins.cmp.mappings")

            -- require('copilot').setup(copilot_opts)
            -- require('copilot_cmp').setup()

            -- require('atuin').setup()
            cmp.setup({
                sources = cmp.config.sources({
                    -- { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'lazydev', group_index = 0 },
                    { name = 'path' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'cmp_yanky' },
                    { name = 'calc' },
                    { name = 'spell' },
                    { name = 'zsh' },
                    { name = 'tmux' },
                    { name = 'emoji' },
                    { name = 'nerdfont' },
                    { name = 'plugins' },
                }, {
                    { name = 'buffer' },
                }),
                -- mapping = {
                --     ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- }
                mapping = cmp.mapping({
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                    ['<C-j>'] = cmp_mappings.next_cmp_item,
                    ['<C-k>'] = cmp_mappings.prev_cmp_item,
                    ['<Tab>'] = cmp_mappings.next_cmp_item,
                    ['<S-Tab>'] = cmp_mappings.prev_cmp_item,
                    ['<M-;>'] = cmp.mapping(function (_)
                       vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
                    end),
                }),
                window = {
                    completion = cmp.config.window.bordered({
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None,CmpItemAbbr:None'
                    }),
                    documentation = cmp.config.window.bordered({
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None,CmpItemAbbr:None'
                    }),
                },
            })
            -- Replaced by wilder.nvim. See ./appearance.lua
            --[[ cmp.setup.cmdline({ '/', '?' }, {
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
            }) ]]
            -- }}}
            require('plugins.dap.config')
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
        -- https://github.com/L3MON4D3/LuaSnip
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            require("luasnip").setup()
            require("luasnip.loaders.from_vscode").lazy_load()
        end
    },
    {
        -- https://github.com/antosha417/nvim-lsp-file-operations
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("lsp-file-operations").setup()
        end
    },
    {
        -- https://github.com/zbirenbaum/copilot.lua
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup(copilot_opts)
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    -- {
    --     'zbirenbaum/copilot-cmp',
    --     dependencies = {
    --         { 'zbirenbaum/copilot.lua' },
    --     }
    -- }
}
