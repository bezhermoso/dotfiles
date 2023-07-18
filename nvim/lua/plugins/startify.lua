return {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
         local alpha = require('alpha')
         local startify = require('alpha.themes.startify')
         local handle = io.popen('fortune -s')
         local fortune = handle:read("*a")
         handle:close()
         startify.section.header.val = fortune
         alpha.setup(startify.config)
    end
}

