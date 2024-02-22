local dapgo = require('dap-go')

vim.keymap.set('n', '<leader>dgt', dapgo.debug_test, {
    desc = 'DAP Go: Debug test',
    buffer = 0,
})
vim.keymap.set('n', '<leader>dgl', dapgo.debug_last_test, {
    desc = 'DAP Go: Debug last test',
    buffer = 0,
})
