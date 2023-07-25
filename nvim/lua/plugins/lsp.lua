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
            { 'quangnguyen30192/cmp-nvim-ultisnips' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-emoji' },
            { 'andersevenrud/cmp-tmux' },
            { 'KadoBOT/cmp-plugins' },
            { 'dmitmel/cmp-cmdline-history' },
            { 'chrisgrieser/cmp-nerdfont' },
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
                },
            })
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
            end)
            -- Make Lua language server understand Neovim API
            require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())
            lsp_zero.setup({
                set_extra_mappings = true,
            })
            -- }}}

            -- COMPLETION {{{
            -- lsp-zero already sets up nvim-cmp for us, here we are simply
            -- setting more configuration e.g. adding sources.
            local cmp = require('cmp')
            cmp.setup({
                sources = {
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'luasnip', priority = 750 },
                    { name = 'buffer', priority = 500 },
                    { name = 'path', priority = 250 },
                    { name = 'nvm_lsp_signature_help' },
                    { name = 'calc' },
                    { name = 'spell' },
                    { name = 'zsh' },
                    { name = 'tmux' },
                    { name = 'emoji' },
                    { name = 'plugins' },
                    { name = 'nerdfont' },
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }
            })
            -- }}}
        end
    },
    {
        'numToStr/Comment.nvim',
        event = 'InsertEnter',
        config = function()
            require('Comment').setup()
        end
    },
}
