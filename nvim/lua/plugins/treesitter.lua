return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query",
                    "php", "go",
                    "javascript", "html", "css",
                    "sql", "bash", "yaml", "json", "jq", "regex", "markdown",
                },
                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {}
    }
}
