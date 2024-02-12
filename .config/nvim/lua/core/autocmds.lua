
local goyamlgroup = vim.api.nvim_create_augroup('GoYamlTemplates', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = goyamlgroup,
  pattern = {'*.yaml.template'},
  callback = function ()
    vim.opt_local.filetype = "gotexttmpl.yaml"
  end
})

local gogroup = vim.api.nvim_create_augroup('GoSrc', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = gogroup,
  pattern = {'*.go'},
  callback = function (bufopts)
    local dapgo = require('dap-go')
    vim.keymap.set('n', '<leader>dgt', dapgo.debug_test, {
      desc = 'DAP Go: Debug test',
      buffer = bufopts.buf,
    })
    vim.keymap.set('n', '<leader>dgl', dapgo.debug_last_test, {
      desc = 'DAP Go: Debug last test',
      buffer = bufopts.buf,
    })
  end
})

