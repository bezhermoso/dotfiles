return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            -- goose.nvim plugin requires this anti_conceal value. See ai.lua
            anti_conceal = { enabled = false },
            file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
    },
}
