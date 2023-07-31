
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

-- "test/repo"
