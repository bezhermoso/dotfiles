return {
    {
        "https://github.com/stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
            layout = {
                max_width = { 40, 0.33 },
                min_width = 20,
            },
            autojump = true,
            filter_kind = {
                "Class",
                "Constructor",
                "Enum",
                "EnumMember",
                "Function",
                "Interface",
                "Module",
                "Method",
                "Struct",
                "NamedType",
                "Namespace",
                "PointerType",
                "Property",
                "ErrorType",
                "FunctionPointerType",
                "Constant",
                "Package",
            },
        },
        keys = {
            { "<leader>ss", "<cmd>AerialToggle!<CR>", desc = "Aerial: Toggle [(s)how (s)tructure]" },
        }
    }
}
