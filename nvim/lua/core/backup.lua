
-- Bootstrap directory when backup files are saved:
local backuppath = vim.fn.stdpath("data") .. "/backups"
if not vim.loop.fs_stat(backuppath) then
  vim.fn.system({
    "mkdir",
    "-p",
    backuppath
  })
end

vim.opt.backupdir:remove(".")
vim.opt.backupdir:remove("~")
vim.opt.backupdir:prepend("./.vim/backup")
vim.opt.backupdir:prepend(backuppath)
vim.opt.backupdir:append(".")

-- Persist undo-files:
vim.opt.backup = true
-- Persist in undopath
