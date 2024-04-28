-- Whether or not file-tree should act as a floating window:
local nvim_tree_float = true

-- Register event subscribers that refocus the file-tree after file/folder creations/renames/delete confirmations.
-- This is only necessary when file-tree is a float window & dismissed when these inputs show up.
local register_events_to_regain_focus = function()
    local api = require("nvim-tree.api")
    local Event = api.events.Event

    local focus_tree = function()
        api.tree.focus()
    end

    -- These events displays a popup & dismisses the floating tree. Refocus (reshow) the tree after the operations:
    api.events.subscribe(Event.NodeRenamed, focus_tree)
    api.events.subscribe(Event.FileCreated, focus_tree)
    api.events.subscribe(Event.FileRemoved, focus_tree)
    api.events.subscribe(Event.FolderCreated, focus_tree)
    api.events.subscribe(Event.FolderRemoved, focus_tree)
end

return {
    'nvim-tree/nvim-tree.lua',
    keys = {
        { '<leader>n', ':NvimTreeFindFileToggle<CR>' }
    },
    config = function()
        local my_on_attach = function (bufnr)
            -- See https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#custom-mappings
            local api = require("nvim-tree.api")
            local treeutils = require("plugins.nvim-tree.treeutils")


            local function keymap_opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.set('n', '<C-f>', treeutils.launch_find_files, keymap_opts('Find files'))
            vim.keymap.set('n', '<C-g>', treeutils.launch_live_grep, keymap_opts('Live grep'))
        end
        require('nvim-tree').setup({
            on_attach = my_on_attach,
            hijack_netrw = true,
            disable_netrw = false,
            hijack_directories = {
                enable = true,
                auto_open = false,
            },
            view = {
                float = {
                    enable = nvim_tree_float,
                    open_win_config = {
                        height = 100,
                        width = 50,
                        border = 'shadow',
                        row = 0,
                        col = 0,
                    },
                },
            },
            renderer = {
                icons = {
                    glyphs = {
                        git = {
                            unstaged = '~',
                            deleted = "✗",
                            untracked = '?',
                        },
                    },
                },
            },
            filters = {
                git_ignored = false,
            },
            update_focused_file = {
                enable = true,
                update_root = true,
            }
        })

        if nvim_tree_float then
            register_events_to_regain_focus()
        end
    end,
}
