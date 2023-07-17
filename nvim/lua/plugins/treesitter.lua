local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
                "c", "lua", "vim", "vimdoc",
                "query", "php", "javascript", "html", "css",
                "sql", "bash", "yaml", "json", "jq",
                "markdown", "regex"
            },
			sync_install = false,
			highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
			indent = { enable = true },
		})
	end
}

return { M }
