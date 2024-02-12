vim.keymap.set('n', '<leader><Space>', ':noh<CR>', {
    desc = 'Clear buffer search'
})

local open_plugin_github_repo = function()
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


-- Quickfix List [[
vim.keymap.set('n', 'cn', ':cnext<CR>', {
    noremap = true,
    silent = true,
    desc = 'Next item in quickfix-list',
})
vim.keymap.set('n', 'cp', ':cprevious<CR>', {
    noremap = true,
    silent = true,
    desc = 'Next item in quickfix-list',
})
vim.keymap.set('n', 'cc', ':cclose<CR>', {
    noremap = true,
    silent = true,
    desc = 'Close quickfix-list',
})
vim.keymap.set('n', 'co', ':copen<CR>', {
    noremap = true,
    silent = true,
    desc = 'Open quickfix-list',
})
-- ]]

-- Text manipulations [[
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", {
    desc = "Move selection down",
    noremap = true,
    silent = true,
})

vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", {
    desc = "Move selection up",
    noremap = true,
    silent = true,
})

vim.keymap.set("x", ">>", function()
    vim.cmd('normal! >>')
    vim.cmd('normal! gv')
end, {
    desc = "Indent",
    noremap = true,
    silent = true,
})
vim.keymap.set("x", "<<", function()
    vim.cmd('normal! <<')
    vim.cmd('normal! gv')
end, {
    desc = "Outdent",
    noremap = true,
    silent = true,
})
vim.keymap.set("x", "<leader>p", '"_dP', {
    desc = "Paste & preserve default register",
    noremap = true,
    silent = true,
})
-- ]]

-- Navigation [[
vim.keymap.set('n', '<leader><Tab>', "<C-^>", {
    desc = "Switch to previous buffer",
    noremap = true,
    silent = true,
})
-- ]]


-- Retroactively copy to system clipboard [[
vim.keymap.set(
    'n',
    '<leader>y',
    function()
        vim.cmd([[ :let @+=@" ]])
        vim.print("Copied default register contents to system clipboard")
    end,
    {
        desc = "Copy default register to system clipboard",
        noremap = true,
        silent = true
    })

vim.keymap.set(
    'n',
    '<leader>p',
    function()
        vim.cmd([[ :let @"=@+ ]])
        vim.print("Copied system clipboard contents to default register")
    end,
    {
        desc = "Copy system clipboard to default register",
        noremap = true,
        silent = true
    })
--]]
