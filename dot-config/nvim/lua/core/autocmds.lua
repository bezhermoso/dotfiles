
local goyamlgroup = vim.api.nvim_create_augroup('GoYamlTemplates', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = goyamlgroup,
  pattern = {'*.yaml.template'},
  callback = function ()
    vim.opt_local.filetype = "gotexttmpl.yaml"
  end
})

local appearancegroup = vim.api.nvim_create_augroup('ModAppearance', { clear = false })
-- Hide cursorline when buffer is not in focus [[[
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'BufWinEnter'}, {
    group = appearancegroup,
    callback = function ()
      vim.opt_local.cursorline = true
    end,
  }
)

vim.api.nvim_create_autocmd({'WinLeave'}, {
    group = appearancegroup,
    callback = function ()
      vim.opt_local.cursorline = false
    end,
  }
)
-- ]]]

-- Disable LSP diagnostics for Claude plans & thoughts files [[[
local plans_diag_group = vim.api.nvim_create_augroup('DisablePlansDiagnostics', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = plans_diag_group,
  pattern = {
    vim.fn.expand('~') .. '/.claude/plans/*.md',
    '*/thoughts/shared/plans/*.md',
    '*/thoughts/shared/research/*.md',
  },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
-- ]]]
