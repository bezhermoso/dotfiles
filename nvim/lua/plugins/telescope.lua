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
            {"<leader>F", ":lua require('telescope.builtin').resume()<CR>", desc = 'Telescope: Resume'},
            {"<leader>*", ":lua require('telescope.builtin').grep_string()<CR>", desc = 'Telescope: Grep string...', mode = {'v', 'n'}},
            {"<leader>fQ", ":lua require('telescope.builtin').quickfixhistory()<CR>", desc = 'Telescope: Quickfix (History)'},
            {"<leader>fb", ":lua require('telescope.builtin').buffers()<CR>", desc = 'Telescope: Buffers'},
            {"<leader>fc", ":lua require('telescope.builtin').colorscheme()<CR>", desc = 'Telescope: Colorschemes'},
            {"<leader>ff", ":lua require('telescope.builtin').find_files()<CR>", desc = 'Telescope: Files'},
            {"<leader>fg", ":lua require('telescope.builtin').live_grep()<CR>", desc = 'Telescope: Live Grep'},
            {"<leader>fh", ":lua require('telescope.builtin').help_tags()<CR>", desc = 'Telescope: Help tags'},
            {"<leader>fm", ":lua require('telescope.builtin').man_pages()<CR>", desc = 'Telescope: man pages'},
            {"<leader>fq", ":lua require('telescope.builtin').quickfix()<CR>", desc = 'Telescope: Quickfix'},
            {"<leader>fr", ":lua require('telescope.builtin').oldfiles()<CR>", desc = 'Telescope: MRU'},
            {"<leader>fs", ":lua require('telescope.builtin').spell_suggest()<CR>", desc = 'Telescope: Spelling Suggestions'},
            {"<leader>fy", ":lua require('telescope.builtin').registers()<CR>", desc = 'Telescope: Registers'},
            {"<leader>ft", ":lua require('telescope.builtin').builtin()<CR>", desc = 'Telescope: Built-in'},
            {"<leader>fGs", ":lua require('telescope.builtin').git_status()<CR>", desc = 'Telescope: Git status'},
            {"<leader>fGb", ":lua require('telescope.builtin').git_branch()<CR>", desc = 'Telescope: Git branches'},
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
