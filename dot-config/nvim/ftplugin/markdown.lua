vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

vim.keymap.set('n', '<leader>h1<Space>', 'yypV$r=', { silent = true, buffer = 0 })
vim.keymap.set('n', '<leader>h2<Space>', 'yypV$r-', { silent = true, buffer = 0 })
vim.keymap.set('n', '<leader>h3<Space>', 'I###', { silent = true, buffer = 0 })
vim.keymap.set('n', '<leader>h4<Space>', 'I####', { silent = true, buffer = 0 })
vim.keymap.set('n', '<leader>h5<Space>', 'I#####', { silent = true, buffer = 0 })
vim.keymap.set('n', '<leader>h6<Space>', 'I######', { silent = true, buffer = 0 })

