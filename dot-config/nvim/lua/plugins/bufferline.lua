return {
    {
        -- https://github.com/akinsho/bufferline.nvim
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        keys = {
            { "]b",  ":BufferLineCycleNext<CR>", { desc = "Go to next buffer", mode = { 'v', 'n' } } },
            { "bn",  ":BufferLineCycleNext<CR>", { desc = "Go to next buffer", mode = { 'v', 'n' } } },
            { "b.",  ":BufferLineCycleNext<CR>", { desc = "Go to next buffer", mode = { 'v', 'n' } } },
            { "[b",  ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer", mode = { 'v', 'n' } } },
            { "bp",  ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer", mode = { 'v', 'n' } } },
            { "b,",  ":BufferLineCyclePrev<CR>", { desc = "Go to previous buffer", mode = { 'v', 'n' } } },
            { "bC,", ":BufferLinePickClose<CR>", { desc = "Pick buffer to close", mode = { 'v', 'n' } } },
            { "gb,", ":BufferLinePick<CR>",      { desc = "Pick buffer", mode = { 'v', 'n' } } },
        },
        config = function()
            local bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    style_preset = bufferline.style_preset.minimal,
                    diagnostics = "nvim_lsp",
                    always_show_bufferline = false,
                }
            })
        end
    }
}
