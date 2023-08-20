return {
    -- {
    --     'nvim-lua/plenary.nvim'
    -- },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            'debugloop/telescope-undo.nvim',
        },
        keys = {
            { "<leader>*",   ":lua require('telescope.builtin').grep_string()<CR>",     desc = 'Telescope: Grep string...', mode = { 'v', 'n' } },
            { "<leader>F",   ":lua require('telescope.builtin').resume()<CR>",          desc = 'Telescope: Resume' },
            { "<leader>fGb", ":lua require('telescope.builtin').git_branch()<CR>",      desc = 'Telescope: Git branches' },
            { "<leader>fGs", ":lua require('telescope.builtin').git_status()<CR>",      desc = 'Telescope: Git status' },
            { "<leader>fO",  ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",    desc = 'Telescope: LSP Symbols (Dynamic)' },
            { "<leader>fQ",  ":lua require('telescope.builtin').quickfixhistory()<CR>", desc = 'Telescope: Quickfix (History)' },
            { "<leader>fa",  ":lua require('telescope.builtin').find_files({ no_ignore = true })<CR>", desc = 'Telescope: Files (All)' },
            { "<leader>fb",  ":lua require('telescope.builtin').buffers()<CR>",         desc = 'Telescope: Buffers' },
            { "<leader>fc",  ":lua require('telescope.builtin').colorscheme()<CR>",     desc = 'Telescope: Colorschemes' },
            { "<leader>ff",  ":lua require('telescope.builtin').find_files({ hidden = true })<CR>",      desc = 'Telescope: Files' },
            { "<leader>fg",  ":lua require('telescope.builtin').live_grep()<CR>",       desc = 'Telescope: Live Grep' },
            { "<leader>fh",  ":lua require('telescope.builtin').help_tags()<CR>",       desc = 'Telescope: Help tags' },
            { "<leader>fm",  ":lua require('telescope.builtin').man_pages()<CR>",       desc = 'Telescope: man pages' },
            { "<leader>fo",  ":lua require('telescope.builtin').lsp_workspace_symbols()<CR>",    desc = 'Telescope: LSP Symbols' },
            { "<leader>fq",  ":lua require('telescope.builtin').quickfix()<CR>",        desc = 'Telescope: Quickfix' },
            { "<leader>fr",  ":lua require('telescope.builtin').oldfiles()<CR>",        desc = 'Telescope: MRU' },
            { "<leader>fs",  ":lua require('telescope.builtin').spell_suggest()<CR>", desc = 'Telescope: Spelling Suggestions' },
            { "<leader>ft",  ":lua require('telescope.builtin').builtin()<CR>",         desc = 'Telescope: Built-in' },
            { "<leader>fu",  ":lua require('telescope').extensions.undo.undo()<CR>",    desc = 'Telescope: Undo' },
            { "<leader>fy",  ":lua require('telescope.builtin').registers()<CR>",       desc = 'Telescope: Registers' },
        },
        config = function(_, opts)
            local telescope = require('telescope')
            telescope.setup({
                defaults = {
                    layout_strategy = 'flex',
                    mappings = {
                        i = {
                            ["<C-j>"] = "move_selection_next",
                            ["<C-k>"] = "move_selection_previous",
                            ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
                        }
                    }
                },
                extensions = {
                    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim#telescope-setup-and-configuration
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                    undo = {
                        side_by_side = true,
                        layout_strategy = 'vertical',
                        layout_config = {
                            preview_height = 0.8,
                        },
                    },
                },
            })
            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
            telescope.load_extension('undo')

            vim.keymap.set('n', '<leader>/', function ()
                require('telescope.builtin').current_buffer_fuzzy_find(
                    require('telescope.themes').get_dropdown({
                        previewer = false,
                    })
                )
            end, { desc = "Find in current buffer..."})
        end,
    },
}
