return {
    {
        "https://github.com/gbprod/yanky.nvim",
        lazy = false,
        config = function()
            local yanky_utils = require("yanky.utils")
            local telescope_mapping = require("yanky.telescope.mapping")
            require("yanky").setup({
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 500,
                },
                picker = {
                    telescope = {
                        mappings = {
                            default = telescope_mapping.put("p"),
                            i = {
                                ["<c-g>"] = telescope_mapping.put("p"),
                                ["<c-x>"] = telescope_mapping.delete(),
                                ["<c-r>"] = telescope_mapping.set_register(yanky_utils.get_default_register()),
                                ["<c-j>"] = "move_selection_next",
                                ["<c-k>"] = "move_selection_previous",
                            },
                            n = {
                                p = telescope_mapping.put("p"),
                                P = telescope_mapping.put("P"),
                                d = telescope_mapping.delete(),
                                r = telescope_mapping.set_register(yanky_utils.get_default_register()),
                                ["<c-j>"] = "move_selection_next",
                                ["<C-k>"] = "move_selection_previous",
                            },
                        }
                    }
                }
            })
        end,
        keys = {
            { "p",  "<Plug>(YankyPutAfter)",   mode = { "x", "n" }, silent = true },
            { "P",  "<Plug>(YankyPutBefore)",  mode = { "x", "n" }, silent = true },
            { "gp", "<Plug>(YankyGPutAfter)",  mode = { "x", "n" }, silent = true },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "x", "n" }, silent = true },
        }
    }
}
