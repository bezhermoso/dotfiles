return {
    {
        -- https://github.com/github/copilot.vim
        'github/copilot.vim',
        cmd = 'Copilot',
        lazy = false,
        config = function()
            vim.keymap.set('i', 'kj', 'copilot#Accept("kj")', {
                expr = true,
                silent = true,
                script = true,
                replace_keycodes = false,
            })
            vim.keymap.set('i', '<M-;>', 'copilot#Accept(";")', {
                expr = true,
                silent = true,
                script = true,
                replace_keycodes = false,
            })
            vim.g.copilot_no_tab_map = true
        end,
        keys = {
            { "<leader>cp", ":Copilot panel<CR>", noremap = true, silent = true, desc = "Copilot panel" },
        },
    },
    {
        'azorng/goose.nvim',
        config = function()
            require('goose').setup({})
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- See markdown.lua
            "MeanderingProgrammer/render-markdown.nvim",
        },
        keys = {
            { "<leader>tgg", function() require("goose.api").toggle() end,                 noremap = true, silent = true, desc = "[T]alk to [G]oose" },
            { "<leader>tgn", function() require("goose.api").open_input_new_session() end, noremap = true, silent = true, desc = "Goose: open input new session" },
            { "<leader>tgc", function() require("goose.api").close() end,                  noremap = true, silent = true, desc = "Goose: close" },
            { "<leader>tgq", function() require("goose.api").stop() end,                   noremap = true, silent = true, desc = "Goose: quit" },
            { "<leader>tgf", function() require("goose.api").select_session() end,         noremap = true, silent = true, desc = "Goose: select session" },
        }
    },
    {
        "yetone/avante.nvim",
        enabled = false,
        -- If you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- for example
            provider = "gemini",
            auto_suggestions_provider = "gemini",
            behavior = {
                auto_suggestions = false,
                auto_set_highlight_group = true,
                auto_set_keymaps = true,
                auto_apply_diff_after_generation = false,
                support_paste_from_clipboard = false,
            },
            providers = {
                gemini = {
                    model = "gemini-2.5-flash",
                    temperature = 0,
                    -- max_tokens = 4096,
                },
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
                moonshot = {
                    endpoint = "https://api.moonshot.ai/v1",
                    model = "kimi-k2-0711-preview",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768,
                    },
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp",      -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua",      -- for file_selector provider fzf
            "stevearc/dressing.nvim", -- for input provider dressing
            "folke/snacks.nvim",     -- for input provider snacks
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
    }
}
