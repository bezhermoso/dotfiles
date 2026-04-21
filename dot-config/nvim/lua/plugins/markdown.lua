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
    {
        "selimacerbas/markdown-preview.nvim",
        dependencies = { "selimacerbas/live-server.nvim" },
        config = function()
            require("markdown_preview").setup({
                -- all optional; sane defaults shown
                port = 8421,
                open_browser = true,
                debounce_ms = 300,
            })
        end,
    },
    {
        "roodolv/markdown-toggle.nvim",
        config = function()
            require("markdown-toggle").setup({
                use_default_keymaps = true
            })
        end,
    }

}
