return {
    {
        -- https://github.com/nvim-treesitter/nvim-treesitter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "comment",
                    "commonlisp",
                    "css",
                    "csv",
                    "diff",
                    "dockerfile",
                    "fish",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "gomod",
                    "gosum",
                    "gowork",
                    "gpg",
                    "graphql",
                    "groovy",
                    "hcl",
                    "html",
                    "http",
                    "java",
                    "javascript",
                    "jq",
                    "json",
                    "jsonc",
                    "latex",
                    "ledger",
                    "lua",
                    "luap",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "mermaid",
                    "org",
                    "passwd",
                    "perl",
                    "php",
                    "proto",
                    "python",
                    "query",
                    "racket",
                    "regex",
                    "requirements",
                    "rust",
                    "scheme",
                    "sql",
                    "svelte",
                    "swift",
                    "terraform",
                    "toml",
                    "tsv",
                    "twig",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "vue",
                    "yaml",
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

            local parsers_config = require('nvim-treesitter.parsers').get_parser_configs()
            -- Register this parser manually to nvim-treesitter's parser directory
            parsers_config.ghostty = {
                install_info = {
                    url = vim.fn.expand("~/.config/nvim/lua/dev/tree-sitter-ghostty"),
                    files = { 'src/parser.c' },
                    branch = 'main',
                    requires_generate_from_grammar = true,
                },
            }
        end
    },
    {
        -- https://github.com/nvim-treesitter/nvim-treesitter-context
        "nvim-treesitter/nvim-treesitter-context",
        opts = {}
    },
    {
        -- https://github.com/folke/todo-comments.nvim
        "folke/todo-comments.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "folke/trouble.nvim" },
        },
        config = function ()
            require("todo-comments").setup()
            vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", {
                desc = "Search for TODOs in the project",
            })
            vim.keymap.set("n", "<leader>te", "<cmd>TodoTrouble<cr>", {
                desc = "Open TODOs in Trouble",
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        "tree-sitter-grammars/tree-sitter-test",
        build = "mkdir parser && tree-sitter build -o parser/test.so",
        ft = "test",
        init = function()
            -- toggle full-width rules for test separators
            vim.g.tstest_fullwidth_rules = false
            -- set the highlight group of the rules
            vim.g.tstest_rule_hlgroup = "FoldColumn"
        end
    }
}
