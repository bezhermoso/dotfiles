local mapkey = vim.keymap.set

mapkey('n', '<leader><Space>', ':noh<CR>', {
    desc = 'Clear buffer search',
    silent = true,
})
mapkey('n', '<Esc>', ':noh<CR>', {
    desc = 'Clear buffer search',
    silent = true,
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

mapkey('n', '<leader>gh', open_plugin_github_repo)


-- Quickfix List [[
mapkey('n', 'cn', ':cnext<CR>', {
    noremap = true,
    silent = true,
    desc = 'Next item in quickfix-list',
})
mapkey('n', 'cp', ':cprevious<CR>', {
    noremap = true,
    silent = true,
    desc = 'Next item in quickfix-list',
})
mapkey('n', 'cc', ':cclose<CR>', {
    noremap = true,
    silent = true,
    desc = 'Close quickfix-list',
})
mapkey('n', 'co', ':copen<CR>', {
    noremap = true,
    silent = true,
    desc = 'Open quickfix-list',
})
-- ]]

mapkey("v", "<C-j>", ":m '>+1<CR>gv=gv", {
    desc = "Move selection down",
    noremap = true,
    silent = true,
})

mapkey("v", "<C-k>", ":m '<-2<CR>gv=gv", {
    desc = "Move selection up",
    noremap = true,
    silent = true,
})

mapkey("n", "<up>", ":m -2", {
    desc = "Move current line up",
    noremap = true,
    silent = true,
})

mapkey("n", "<down>", ":m +1", {
    desc = "Move current line up",
    noremap = true,
    silent = true,
})

-- Indent/outdent while preserving visual selection [[
mapkey("x", ">>", function()
    vim.cmd('normal! >>')
    vim.cmd('normal! gv')
end, {
    desc = "Indent",
    noremap = true,
    silent = true,
})
mapkey("x", "<<", function()
    vim.cmd('normal! <<')
    vim.cmd('normal! gv')
end, {
    desc = "Outdent",
    noremap = true,
    silent = true,
})
-- ]]

-- Navigation [[
mapkey('n', '<leader><Tab>', "<C-^>", {
    desc = "Switch to previous buffer",
    noremap = true,
    silent = true,
})
mapkey('n', 'bx', ":bd<CR>", {
    desc = "Unload buffer",
    noremap = true,
    silent = true,
})
mapkey('n', 'bc', ":bd<CR>", {
    desc = "Unload buffer",
    noremap = true,
    silent = true,
})
mapkey('n', 'bX', ":bw!<CR>", {
    desc = "Force-unload buffer",

    noremap = true,
    silent = true,
})
-- ]]

-- Registers [[[
mapkey("x", "<leader>P", '"_dP', {
    desc = "Paste & preserve default register",
    noremap = true,
    silent = true,
})

-- Blackhole:
mapkey({ "n", "v" }, "<BS>", "\"_d")
mapkey({ "n", "v" }, "<BS><BS>", "\"_dd")
-- ]]]

-- Retroactively copy to system clipboard [[
mapkey(
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

mapkey(
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

-- Keep search results centered [[[
mapkey('n', 'n', 'nzz', { silent = true, noremap = true })
mapkey('n', 'N', 'Nzz', { silent = true, noremap = true })
mapkey('n', '*', '*zz', { silent = true, noremap = true })
mapkey('n', 'g*', 'g*zz', { silent = true, noremap = true })
mapkey('n', '#', '#zz', { silent = true, noremap = true })
mapkey('n', 'g#', 'g#zz', { silent = true, noremap = true })
-- ]]]

-- Tame vim's regex [[[
mapkey({ 'n', 'v' }, '/', '/\\v', { noremap = true })
mapkey({ 'n', 'v' }, '?', '?\\v', { noremap = true })
-- ]]]
-- Folding [[[
-- FIX: <Tab> and <C-i> are synonymous: these keymaps conflict with jumplist navigation. Find more apropos keymap.
-- mapkey('n', '<Tab><Tab>', 'za', { noremap = true })
-- mapkey('n', '<S-Tab><S-Tab>', 'zA', { noremap = true })
-- ]]]
-- Open terminal split below buffer [[[
mapkey( 'n', '<C-w>`', ':below 15sp term://$SHELL<CR>')
-- ]]]
-- Enter normal mode in terminal buffers [[[
mapkey('t', '<C-\\><C-\\>', '<C-\\><C-n>')
-- ]]]
--
--
--
mapkey('v', '<leader>tr', function ()
    vim.cmd([[silent :'<,'>w !tmux load-buffer -]])
    vim.cmd([[silent :! ~/.config/tmux/runner.zsh ]])
end, { noremap = true, silent = true })
mapkey('n', '<leader>tr', function ()
    vim.cmd([[silent :.w !tmux load-buffer -]])
    vim.cmd([[silent :! ~/.config/tmux/runner.zsh ]])
end, { noremap = true, silent = true })

