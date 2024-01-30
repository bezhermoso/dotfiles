local copilot_opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
}

return {
    {
        'VonHeikemen/lsp-zero.nvim',
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
            { "folke/neodev.nvim" },
            { 'zbirenbaum/copilot-cmp' },
        },
        config = function()
            -- Language Server Protocol (LSP) {{{
            local lsp_zero = require('lsp-zero')
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
                local open_line_diagnostic = function()
                    -- vim.diagnostic.open_float(0, { scope = "line" })
                    vim.diagnostic.open_float({ scope = "line" })
                end
                vim.keymap.set('n', '<leader>e', open_line_diagnostic, {
                    desc = 'LSP: Line Diagnostics'
                })
            end)
            -- Configure Lua LSP to understand Neovim plugin structures, etc.
            require('neodev').setup()
            require('mason').setup()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'gopls',        -- Go
                    'intelephense', -- PHP
                    'lua_ls',       -- Lua
                    'phpactor',     -- PHP
                    'yamlls',       -- YAML
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
                                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
                                "*api*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
                                "*docker-compose*.{yml,yaml}",
                                ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.son"] =
                                    "*flow*.{yml,yaml}",
                            },
                        })
                    end
                }
            })

            -- COMPLETION {{{
            -- lsp-zero already sets up nvim-cmp for us, here we are simply
            -- setting more configuration e.g. adding sources.
            local cmp = require('cmp')

            -- require('copilot').setup(copilot_opts)
            -- require('copilot_cmp').setup()

            -- require('atuin').setup()
            cmp.setup({
                sources = {
                    -- { name = 'copilot' },
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
                -- mapping = {
                --     ['<CR>'] = cmp.mapping.confirm({ select = true }),
                -- }
                mapping = cmp.mapping({
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    })
                })
            })

            cmp.setup.cmdline({ '/', '?' }, {
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
                        { name = 'git ' }
                    },
                    {
                        { name = 'buffer' }
                    }
                )
            })

            cmp.setup.filetype({ 'bash', 'zsh', 'markdown' }, {
                sources = cmp.config.sources(
                    {
                        { name = 'git ' }
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
            --
            -- DAP {{{
            local dap = require('dap')
            local dapui = require('dapui')
            require('nvim-dap-virtual-text').setup({})
            dapui.setup()
            require('mason-nvim-dap').setup({
                ensure_installed = {
                    "delve",
                    "bash-debug-adapter",
                    "php-debug-adapter",
                },
                automatic_installation = true,
            })

            -- Open/close dapui automatically on DAP events
            dap.listeners.before.attach.dapui_config = function ()
               dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function ()
               dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function ()
               dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function ()
               dapui.close()
            end

            require('dap-go').setup({
                dap_configurations = {
                    {
                        type = "go",
                        name = "Attach to remote debugger",
                        mode = "remote",
                        request = "attach",
                    }
                },
                delve = {
                    port = 5005,
                }
            })

            vim.keymap.set('n', '<leader>dui', function() require('dapui').toggle() end, {
                desc = 'DAP: Open DAP UI',
            })
            vim.keymap.set('n', '<leader>ds', function() require('dap').continue() end, {
                desc = 'DAP: Start/Continue',
            })
            vim.keymap.set('n', '<leader>dS', function() require('dap').stop() end, {
                desc = 'DAP: Stop',
            })
            vim.keymap.set('n', '<leader>dt', function() require('dap').toggle_breakpoint() end, {
                desc = 'DAP: Toggle breakpoint',
            })
            vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, {
                desc = 'DAP: Step into',
            })
            vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, {
                desc = 'DAP: Step over',
            })
            vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, {
                desc = 'DAP: Step out',
            })
            -- For Go debugging keymaps, see ../core/autocmds.lua
            -- }}}
            vim.api.nvim_create_autocmd('FileType', {
                callback = function (fopts)
                    if not fopts.match == "go" then
                        return nil
                    end
                    local dapgo = require('dap-go')
                    vim.keymap.set('n', '<leader>dgt', dapgo.debug_test, {
                        desc = 'DAP Go: Debug test',
                        buffer = fopts.buf,
                    })
                    vim.keymap.set('n', '<leader>dgl', dapgo.debug_last_test, {
                        desc = 'DAP Go: Debug last test',
                        buffer = fopts.buf,
                    })
                end
            })


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
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    -- {
    --     'zbirenbaum/copilot.lua',
    --     cmd = 'Copilot',
    --     event = 'InsertEnter',
    --     config = function()
    --         require('copilot').setup(copilot_opts)
    --     end
    -- },
    -- {
    --     'zbirenbaum/copilot-cmp',
    --     dependencies = {
    --         { 'zbirenbaum/copilot.lua' },
    --     }
    -- }
}
