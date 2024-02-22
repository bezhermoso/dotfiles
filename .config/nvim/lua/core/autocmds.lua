
local goyamlgroup = vim.api.nvim_create_augroup('GoYamlTemplates', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = goyamlgroup,
  pattern = {'*.yaml.template'},
  callback = function ()
    vim.opt_local.filetype = "gotexttmpl.yaml"
  end
})
