--Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local dev_opts = {}

if vim.env.LAZY_NVIM_DEV_PATH then
    dev_opts.path = vim.env.LAZY_NVIM_DEV_PATH
end
require("lazy").setup({
    spec = 'plugins',
    dev = dev_opts,
    ui = {
      border = "rounded",
    }
})

