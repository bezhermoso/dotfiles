-- Bootstrap directory when undo data are saved:
local swappath = vim.fn.stdpath("data") .. "/swap"
if not vim.loop.fs_stat(swappath) then
  vim.fn.system({
    "mkdir",
    "-p",
    swappath
  })
end
vim.opt.directory = "./.vim/swap"
vim.opt.directory:prepend(swappath)
vim.opt.directory:append(".")


