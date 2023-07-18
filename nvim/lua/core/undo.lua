-- Bootstrap directory when undo data are saved:
local undopath = vim.fn.stdpath("data") .. "/undo"
if not vim.loop.fs_stat(undopath) then
  vim.fn.system({
    "mkdir",
    "-p",
    undopath
  })
end
vim.opt.undodir = "./.vim/undo"
vim.opt.undodir:prepend(undopath)

-- Persist undo-files:
vim.opt.undofile = true
-- Persist in undopath
