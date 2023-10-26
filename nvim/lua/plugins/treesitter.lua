return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                after = 'nvim-treesitter/nvim-treesitter',
            }
        },
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    'bash',
                    'c',
                    'comment',
                    'commonlisp',
                    'css',
                    'csv',
                    'diff',
                    'dockerfile',
                    'fish',
                    'git_config',
                    'git_rebase',
                    'gitattributes',
                    'gitcommit',
                    'gitignore',
                    'go',
                    'gomod',
                    'gosum',
                    'gowork',
                    'gpg',
                    'graphql',
                    'groovy',
                    'hcl',
                    'html',
                    'http',
                    'java',
                    'javascript',
                    'jq',
                    'json',
                    'jsonc',
                    'latex',
                    'ledger',
                    'lua',
                    'luap',
                    'make',
                    'markdown',
                    'markdown_inline',
                    'mermaid',
                    'org',
                    'passwd',
                    'perl',
                    'php',
                    'proto',
                    'python',
                    'query',
                    'racket',
                    'regex',
                    'requirements',
                    'rust',
                    'scheme',
                    'sql',
                    'svelte',
                    'swift',
                    'terraform',
                    'toml',
                    'tsv',
                    'twig',
                    'typescript',
                    'vim',
                    'vimdoc',
                    'vue',
                    'yaml',
                },
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                -- incremental_selection = {
                --     enable = true,
                --     keymaps = {
                --         init_selection = '<leader>s',
                --         node_incremental = '<leader>s',
                --         scope_incremental = '<leader>s',
                --         node_decremental = '<leader>S',
                --     }
                -- }
            })
            vim.opt.foldmethod = "expr"
            vim.opt.foldenable = false
            vim.cmd([[set foldexpr=nvim_tresitter#foldexpr()]])

            -- Fix treesitter folding: https://github.com/nvim-telescope/telescope.nvim/issues/699#issuecomment-1572977083
            vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufWinEnter" }, {
                group = vim.api.nvim_create_augroup("ts_fold_workaround", { clear = true }),
                command = "set foldexpr=nvim_treesitter#foldexpr()",
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {}
    },
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },
}
