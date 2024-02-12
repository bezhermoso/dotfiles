return {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local alpha = require('alpha')
        local startify = require('alpha.themes.dashboard')
        local handle = io.popen('fortune -s')
        if handle ~= nil then
            local fortune = handle:read("*a")
            handle:close()
            startify.section.header.val = fortune
        end
        alpha.setup(startify.config)
    end
}
