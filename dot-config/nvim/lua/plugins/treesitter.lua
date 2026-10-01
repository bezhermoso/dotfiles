return {
    {
        -- https://github.com/nvim-treesitter/nvim-treesitter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*", -- Triggers for all filetypes
                callback = function()
                    -- Attempt to start Treesitter for the current buffer
                    pcall(vim.treesitter.start)

                    -- Optional: Auto-enable Treesitter-based indentation

                    local ignore_ts_indent_fts = {
                        ["go"] = true,
                    }
                    
                    if ignore_ts_indent_fts[vim.bo.filetype] then
                        return
                    end

                    local ok, ts_indent = pcall(require, "nvim-treesitter.indent")
                    if ok then
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter.indent'.indentexpr()"
                    end
                end,
            })
            require("nvim-treesitter").setup({
                -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
                install_dir = vim.fn.stdpath("data") .. "/site",
            })
            require("nvim-treesitter").install({
                "bash",
                "c",
                "comment",
                "commonlisp",
                "css",
                "csv",
                "diff",
                "dockerfile",
                "elixir",
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
                "haskell",
                "hcl",
                "html",
                "http",
                "java",
                "javascript",
                "jq",
                "json",
                "kotlin",
                "latex",
                "ledger",
                "lua",
                "luap",
                "make",
                "markdown",
                "markdown_inline",
                "mermaid",
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
            })
            vim.opt.foldmethod = "expr"
            vim.opt.foldenable = false
            vim.cmd([[set foldexpr=nvim_tresitter#foldexpr()]])

            -- Fix treesitter folding: https://github.com/nvim-telescope/telescope.nvim/issues/699#issuecomment-1572977083
            vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufWinEnter" }, {
                group = vim.api.nvim_create_augroup("ts_fold_workaround", { clear = true }),
                command = "set foldexpr=nvim_treesitter#foldexpr()",
            })
        end,
    },
    {
        -- https://github.com/nvim-treesitter/nvim-treesitter-context
        "nvim-treesitter/nvim-treesitter-context",
        branch = "master",
        opts = {},
    },
    {
        -- https://github.com/folke/todo-comments.nvim
        "folke/todo-comments.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "folke/trouble.nvim" },
        },
        config = function()
            require("todo-comments").setup()
            vim.keymap.set("n", "<leader>tt", "<cmd>TodoTelescope<cr>", {
                desc = "Search for TODOs in the project",
            })
            vim.keymap.set("n", "<leader>te", "<cmd>TodoTrouble<cr>", {
                desc = "Open TODOs in Trouble",
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        opts = {},
    },
    {
        "tree-sitter-grammars/tree-sitter-test",
        build = "rm -rf parser && mkdir parser && tree-sitter build -o parser/test.so",
        ft = "test",
        init = function()
            -- toggle full-width rules for test separators
            vim.g.tstest_fullwidth_rules = false
            -- set the highlight group of the rules
            vim.g.tstest_rule_hlgroup = "FoldColumn"
        end,
    },
    {
        "bezhermoso/tree-sitter-ghostty",
        dev = true,
        build = "make nvim_install",
    },
    {
        "RRethy/nvim-treesitter-endwise",
    },
    {
        "RRethy/nvim-treesitter-textsubjects",
        -- It doesn't yet support nvim-treesitter rewrite
        cond = false,
    },
}
