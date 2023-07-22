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
        },
        keys = {
            {"<leader>F", ":lua require('telescope.builtin').resume()<CR>"},
            {"<leader>fG", ":lua require('telescope.builtin').grep_string()<CR>"},
            {"<leader>fQ", ":lua require('telescope.builtin').quickfixhistory()<CR>"},
            {"<leader>fb", ":lua require('telescope.builtin').buffers()<CR>"},
            {"<leader>fc", ":lua require('telescope.builtin').colorscheme()<CR>"},
            {"<leader>ff", ":lua require('telescope.builtin').find_files()<CR>"},
            {"<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>"},
            {"<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>"},
            {"<leader>fm", ":lua require('telescope.builtin').man_pages()<CR>"},
            {"<leader>fq", ":lua require('telescope.builtin').quickfix()<CR>"},
            {"<leader>fr", ":lua require('telescope.builtin').oldfiles()<CR>"},
            {"<leader>fs", ":lua require('telescope.builtin').spell_suggest()<CR>"},
            {"<leader>fy", ":lua require('telescope.builtin').registers()<CR>"},
            {"<leader>ft", ":lua require('telescope.builtin').builtin()<CR>"},
        },
        config = function(plugin, opts)
            local telescope = require('telescope')
            telescope.setup(opts)
            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
        end,
        opts = {
            defaults = {
                layout_strategy = 'flex',
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
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
                }
            }
        }
    }
}
