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
                    'diff',
                    'dockerfile',
                    'git_config',
                    'git_rebase',
                    'gitattributes',
                    'gitcommit',
                    'gitignore',
                    'go',
                    'gomod',
                    'gosum',
                    'gowork',
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
                    'lua',
                    'make',
                    'markdown',
                    'markdown_inline',
                    'mermaid',
                    'org',
                    'passwd',
                    'php',
                    'proto',
                    'python',
                    'query',
                    'racket',
                    'regex',
                    'scheme',
                    'sql',
                    'swift',
                    'terraform',
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
