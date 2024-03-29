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
            'nvim-telescope/telescope-file-browser.nvim',
            'gbprod/yanky.nvim',
        },
        keys = {
            { "<leader>*",   ":lua require('telescope.builtin').grep_string()<CR>",                    desc = 'Telescope: Grep string...',       mode = { 'v', 'n' } },
            { "<leader>F",   ":lua require('telescope.builtin').resume()<CR>",                         desc = 'Telescope: Resume' },
            { "<leader>fGb", ":lua require('telescope.builtin').git_branch()<CR>",                     desc = 'Telescope: Git branches' },
            { "<leader>fGs", ":lua require('telescope.builtin').git_status()<CR>",                     desc = 'Telescope: Git status' },
            { "<leader>fO",  ":lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",  desc = 'Telescope: LSP Symbols (Dynamic)' },
            { "<leader>fQ",  ":lua require('telescope.builtin').quickfixhistory()<CR>",                desc = 'Telescope: Quickfix (History)' },
            { "<leader>fa",  ":lua require('telescope.builtin').find_files({ no_ignore = true })<CR>", desc = 'Telescope: Files (All)' },
            { "<leader>fb",  ":lua require('telescope.builtin').buffers()<CR>",                        desc = 'Telescope: Buffers' },
            { "<leader>fc",  ":lua require('telescope.builtin').colorscheme()<CR>",                    desc = 'Telescope: Colorschemes' },
            { "<leader>ff",  ":lua require('telescope.builtin').find_files({ hidden = true })<CR>",    desc = 'Telescope: Files' },
            { "<leader>fg",  ":lua require('telescope.builtin').live_grep()<CR>",                      desc = 'Telescope: Live Grep' },
            { "<leader>fh",  ":lua require('telescope.builtin').help_tags()<CR>",                      desc = 'Telescope: Help tags' },
            { "<leader>fm",  ":lua require('telescope.builtin').man_pages()<CR>",                      desc = 'Telescope: man pages' },
            { "<leader>fo",  ":lua require('telescope.builtin').lsp_workspace_symbols()<CR>",          desc = 'Telescope: LSP Symbols' },
            { "<leader>fp",  ":lua require('telescope.builtin').builtin()<CR>",                        desc = 'Telescope: Built-in' },
            { "<leader>fq",  ":lua require('telescope.builtin').quickfix()<CR>",                       desc = 'Telescope: Quickfix' },
            { "<leader>fr",  ":lua require('telescope.builtin').oldfiles()<CR>",                       desc = 'Telescope: MRU' },
            { "<leader>fs",  ":lua require('telescope.builtin').spell_suggest()<CR>",                  desc = 'Telescope: Spelling Suggestions' },
            { "<leader>ft",  ":lua require('telescope').extensions.file_browser.file_browser()<CR>",   desc = 'Telescope: File tree' },
            { "<leader>fu",  ":lua require('telescope').extensions.undo.undo()<CR>",                   desc = 'Telescope: Undo' },
            { "<leader>fy",  ":lua require('telescope.builtin').registers()<CR>",                      desc = 'Telescope: Registers' },
            { "<leader>fY",  ":Telescope yank_history<CR>",                                            desc = 'Telescope: Yank history' },
        },
        config = function(_, opts)
            local telescope = require('telescope')

            -- Taken from https://github.com/nvim-telescope/telescope.nvim/issues/2201#issuecomment-1284691502
            local ts_select_dir_for_grep = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local fb = require("telescope").extensions.file_browser
                local live_grep = require("telescope.builtin").live_grep
                local current_line = action_state.get_current_line()

                fb.file_browser({
                    files = false,
                    depth = false,
                    attach_mappings = function(prompt_bufnr)
                        require("telescope.actions").select_default:replace(function()
                            local entry_path = action_state.get_selected_entry().Path
                            local dir = entry_path:is_dir() and entry_path or entry_path:parent()
                            local relative = dir:make_relative(vim.fn.getcwd())
                            local absolute = dir:absolute()

                            live_grep({
                                results_title = relative .. "/",
                                cwd = absolute,
                                default_text = current_line,
                            })
                        end)

                        return true
                    end,
                })
            end

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
                pickers = {
                    live_grep = {
                        mappings = {
                            i = {
                                ["<C-f>"] = ts_select_dir_for_grep,
                            },
                            n = {
                                ["<C-f>"] = ts_select_dir_for_grep,
                            },
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
                    file_browser = {
                        theme = 'ivy',
                        hijack_netrw = true,
                        mappings = {
                            i = {
                                ["<C-h>"] = require('telescope').extensions.file_browser.actions.goto_home_dir,
                                ["<C-p>"] = require('telescope.actions.layout').toggle_preview,
                            }
                        }
                    },
                },
            })
            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
            telescope.load_extension('undo')
            telescope.load_extension('file_browser')
            --telescope.load_extension('yank_history')

            vim.keymap.set('n', '<leader>/', function()
                require('telescope.builtin').current_buffer_fuzzy_find(
                    require('telescope.themes').get_dropdown({
                        previewer = false,
                    })
                )
            end, { desc = "Find in current buffer..." })
        end,
    },
}
