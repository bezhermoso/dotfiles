-- Configure debugging protocol tools. Intended to be required (ran) during LSP setup
local dap = require('dap')
local dapui = require('dapui')
require('nvim-dap-virtual-text').setup({})
dapui.setup()
require('mason-nvim-dap').setup({
    ensure_installed = {
        "delve",
        "bash-debug-adapter",
        "php-debug-adapter",
    },
    automatic_installation = true,
})

-- Open/close dapui automatically on DAP events
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

require('dap-go').setup({
    dap_configurations = {
        {
            type = "go",
            name = "Attach to remote debugger",
            mode = "remote",
            request = "attach",
        }
    },
    delve = {
        port = "${port}"
    },
    -- delve = {
    --     port = 5005,
    -- }
})

vim.keymap.set('n', '<leader>dui', function() require('dapui').toggle() end, {
    desc = 'DAP: Open DAP UI',
})
vim.keymap.set('n', '<leader>ds', function() require('dap').continue() end, {
    desc = 'DAP: Start/Continue',
})
vim.keymap.set('n', '<leader>dS', function() require('dap').close() end, {
    desc = 'DAP: Stop',
})
vim.keymap.set('n', '<leader>dt', function() require('dap').toggle_breakpoint() end, {
    desc = 'DAP: Toggle breakpoint',
})
vim.keymap.set('n', '<leader>di', function() require('dap').step_into() end, {
    desc = 'DAP: Step into',
})
vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, {
    desc = 'DAP: Step over',
})
vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end, {
    desc = 'DAP: Step out',
})
-- For Go debugging keymaps, see ../../../ftplugin/go.lua
