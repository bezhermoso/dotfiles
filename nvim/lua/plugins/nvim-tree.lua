return {
    'nvim-tree/nvim-tree.lua',
    keys = {
        { '<leader>n', ':NvimTreeFindFileToggle<CR>' }
    },
    config = function()
        require('nvim-tree').setup({
            hijack_directories = {
                enable = false,
                auto_open = false,
            },
            view = {
                float = {
                    enable = true,
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
            }
        })
    end,
}
