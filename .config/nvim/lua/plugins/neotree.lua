-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#find-with-telescope
local function telescope_opts(state, path)
    return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr)
            local actions = require("telescope.actions")
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                local filename = selection.filename
                if (filename == nil) then
                    filename = selection[1]
                end
                -- any way to open the file without triggering auto-close event of neo-tree?
                require("neo-tree.sources.filesystem").navigate(state, state.path, filename, function() end)
            end)
            return true
        end
    }
end

return {
    {
        "https://github.com/nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        keys = {
            { "<leader>n", ":Neotree reveal<CR>", desc = "Neo-tree: reveal", silent = true },
            { "\\",        ":Neotree reveal<CR>", desc = "Neo-tree: reveal", silent = true }
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = "rounded",
                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                    "document_symbols",
                },
                 -- when opening files, do not use windows containing these filetypes or buftypes
                open_files_do_not_replace_types = {
                    "terminal", "Trouble", "qf", "edgy",
                    "aerial",
                    "spectre_panel",
                    "NeogitStatus", "NeogitLogView", "NeogitDiff", "NeogitCommitMessage",
                    "DiffviewFiles",
                },
                source_selector = {
                    winbar = true,
                    show_scrolled_off_parent_node = true,
                    sources = { -- table
                        {
                            source = "filesystem",
                            display_name = " 󰉓 Files ",
                        },
                        {
                            source = "buffers",
                            display_name = " 󰈚 Buffers ",
                        },
                        {
                            source = "git_status",
                            display_name = " 󰊢 Git ",
                        },
                        {
                            source = "document_symbols",
                            display_name = "  Symbols ",
                        },
                    },
                },
                window = {
                    position = "float",
                    popup = {
                        -- Position floating window to the left, as-if its a side-drawer going over buffers
                        -- Change to 50% to center it.
                        position = "0%",
                        border = "shadow",
                        size = {
                            height = "100%",
                            width = "40%",
                        },
                    },

                    mappings = {
                        ["<CR>"] = "open_drop",
                        -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#switch-between-filesystem-buffers-and-git_status [[[
                        ["vf"] = {
                            function() vim.api.nvim_exec2("Neotree focus filesystem", {}) end,
                            desc = "show filesystem",
                        },
                        ["vb"] = {
                            function() vim.api.nvim_exec2("Neotree focus buffers", {}) end,
                            desc = "show buffers",
                        },
                        ["vg"] = {
                            function() vim.api.nvim_exec2("Neotree focus git_status", {}) end,
                            desc = "show git status",
                        },
                        ["vd"] = {
                            function() vim.api.nvim_exec2("Neotree focus document_symbols", {}) end,
                            desc = "show document symbols",
                        },
                        -- ]]]
                        ["i"] = {
                            "run_command",
                            desc = "Run command on node..."
                        },
                        ["<leader>ff"] = {
                            "telescope_find",
                            desc = "Find in node with Telescope",
                        },
                        ["<leader>fg"] = {
                            "telescope_grep",
                            desc = "Grep in node with Telescope",
                        },
                    },
                },
                commands = {
                    -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes#run-command
                    run_command = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.api.nvim_input(": " .. path .. "<Home>")
                    end,
                    telescope_find = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require('telescope.builtin').find_files(telescope_opts(state, path))
                    end,
                    telescope_grep = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        require('telescope.builtin').live_grep(telescope_opts(state, path))
                    end,
                },
                filesystem = {
                    filtered_items = {
                        visible = true,
                        never_show = {
                            ".git"
                        },
                    },
                    follow_current_file = {
                        enabled = true,
                    },
                },
                event_handlers = {
                    {
                        -- Start in Normal mode within Neotree popups
                        event = "neo_tree_popup_input_ready",
                        ---@param args { bufnr: integer, winid: integer }
                        handler = function(args)
                            vim.cmd("stopinsert")
                            vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
                        end,
                    },
                },
            })
        end
    }
}
