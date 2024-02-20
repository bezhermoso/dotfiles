return {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local alpha = require('alpha')
        local dashboard = require('alpha.themes.dashboard')
        local handle = io.popen('fortune -s')
        local startify = require("plugins.alpha.startify-centered").config
        if handle ~= nil then
            local fortune = handle:read("*a")
            handle:close()
            dashboard.section.header.val = fortune
            startify.layout[2].val = vim.split(fortune, "\n")
        end
        alpha.setup(startify)
    end
}


