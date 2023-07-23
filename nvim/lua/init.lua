require("core.options")

-- TODO: Disable treesitter highlights to work with catppuccin: https://github.com/catppuccin/nvim#wrong-treesitter-highlights

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

require("lazy").setup("plugins")

require("core.backup")
require("core.undo")
require("core.swap")

require('core.keymaps')
