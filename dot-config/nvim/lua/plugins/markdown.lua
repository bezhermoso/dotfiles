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
        "selimacerbas/mdkite.nvim",
        dependencies = { "selimacerbas/kitehost.nvim" },
        config = function()
            require("mdkite").setup({
                -- all optional; sane defaults shown
                instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
                port = 0,         -- 0 = auto (8421 for takeover, OS-assigned for multi)
                open_browser = true,
                default_theme = "dark", -- "dark" or "light"; initial preview theme
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
