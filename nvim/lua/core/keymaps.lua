
vim.keymap.set('n', '<leader><Space>', ':noh<CR>', {
    desc = 'Clear buffer search'
})

local open_plugin_github_repo = function ()
    local plugin = vim.fn.expand('<cWORD>')
    if plugin == nil then
        return
    end
    plugin = string.gsub(plugin, '"', '')
    plugin = string.gsub(plugin, '\'', '')
    local cmd = '!open https://github.com/' .. plugin
    vim.cmd(cmd)
end

vim.keymap.set('n', '<leader>gh', open_plugin_github_repo)


vim.keymap.set('n', 'cn', ':cnext<CR>', {
    desc = 'Next item in quickfix-list',
})
vim.keymap.set('n', 'cp', ':cprevious<CR>', {
    desc = 'Next item in quickfix-list',
})
vim.keymap.set('n', 'cc', ':cclose<CR>', {
    desc = 'Close quickfix-list',
})
vim.keymap.set('n', 'co', ':copen<CR>', {
    desc = 'Open quickfix-list',
})

