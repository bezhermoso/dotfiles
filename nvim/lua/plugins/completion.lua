return {
    {
        'numToStr/Comment.nvim',
        event = 'InsertEnter',
        config = function()
            require('Comment').setup()
        end
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            'SirVer/ultisnips',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-calc',
            'f3fora/cmp-spell',
            'tamago324/cmp-zsh',
            'quangnguyen30192/cmp-nvim-ultisnips',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-emoji',
            'andersevenrud/cmp-tmux',
            'KadoBOT/cmp-plugins',
            'dmitmel/cmp-cmdline-history',
            'chrisgrieser/cmp-nerdfont',
        },
        event = 'InsertEnter',
        config = function ()
            require('cmp-plugins').setup({
                files = { '.dotfiles/nvim/plugins/' },
            })
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn['UltiSnips#Anon'](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
                    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
                    ['<C-M-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-M-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    ['<C-y>'] = cmp.config.disable,
                    ['<C-e>'] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp', priority = 1000 },
                    { name = 'ultisnips', priority = 750 },
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
                }, {
                        { name = 'buffer' },
                    }),
                matching = {
                    disallow_fuzzy_matching = false,
                }
            })
            -- configure `cmp-cmdline` as described in their repo: https://github.com/hrsh7th/cmp-cmdline#setup
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                    { name = "cmdline_history" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                    { name = "cmdline_history" },
                }, {
                        {
                            name = "cmdline",
                            option = {
                                ignore_cmds = { "Man", "!" },
                            },
                        },
                    }),
            })
        end
    }
}
