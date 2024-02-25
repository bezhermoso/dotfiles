
local goyamlgroup = vim.api.nvim_create_augroup('GoYamlTemplates', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = goyamlgroup,
  pattern = {'*.yaml.template'},
  callback = function ()
    vim.opt_local.filetype = "gotexttmpl.yaml"
  end
})

-- Hide cursorline when buffer is not in focus [[[
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'BufWinEnter'}, { callback = function ()
      vim.opt_local.cursorline = true
    end,
  }
)

vim.api.nvim_create_autocmd({'WinLeave'}, {
    callback = function ()
      vim.opt_local.cursorline = false
    end,
  }
)
-- ]]]
