
-- Enable highlight groups
vim.opt.termguicolors = true

-- Use <SPACE> as leader key
vim.g.mapleader = " "

-- CODING STYLE {{{
-- Show tabs as if they are 4-chars width
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Wrapping
vim.opt.wrap = true
vim.opt.textwidth = 120
-- Show vertical column one line to the right of textwidth:
vim.opt.colorcolumn = '+1'
-- vim.opt.formatoptions = "qrn1" -- Previous value. Testing out defualt
-- }}}

-- BUFFERS {{{

vim.opt.title = true

-- Relative line numbering
vim.opt.relativenumber = true
vim.opt.number = true

-- Highlight current line of cursor
vim.opt.cursorline = true

-- Horizontal rulers
vim.opt.ruler = true
vim.opt.laststatus = 2

-- Keep this amount of line above or below the cursor when moving around.
vim.opt.scrolloff = 8
-- Show tab-bar only when there are more than one tab.
vim.opt.showtabline = 1

-- Indicate characters that are otherwise invisible or indistinguishable from others.
vim.opt.list = true
vim.opt.listchars:append "trail:∙"

-- Create horizontal splits to the bottom:
vim.opt.splitbelow = true

-- Create vertical splits to the right:
vim.opt.splitright = true


vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- excludes "usetab"; prevent jumping to existing buffers in tabs.
vim.opt.switchbuf = "useopen,uselast"

-- Translucent pop-up menus:
vim.opt.pumblend = 3

-- }}}


-- FOLDING {{{
vim.opt.foldmethod = "syntax"
vim.opt.foldnestmax = 20
vim.opt.foldenable = false
vim.opt.foldlevel = 1
-- Fold anything from level 10+
vim.opt.foldlevelstart = 10
-- }}}


-- FILE-SYSTEM
vim.opt.autoread = true

-- SEARCH {{{

-- Hihglight search results
vim.opt.hlsearch = true
-- Incremental search
vim.opt.incsearch = true
-- Only perform case-sensitive case when search text is mixed-case:
vim.opt.smartcase = true
vim.opt.magic = true


-- MATCHING {{{
vim.opt.showmatch = true
-- }}}


-- GLOBBING {{{
-- vim:opt.wildmode = "list:longest" -- My previous setting
vim.opt.wildmode = "full" -- Trying this out
-- Show in pop-up menu:
vim.opt.wildoptions = "pum"

-- }}}

-- SCRIPTING PROVIDERS {{{
-- let g:python_host_prog=$HOME.'/.pyenv/versions/neovim2/bin/python'
vim.g.python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'


-- Inspired by https://jaketrent.com/post/set-node-version-nvim/
-- Instead of hard-coding the node host prog here, we optionally
-- set it if NVIM_HOST_PROG_PATH is present. This allows this
-- to be machine-specific.
local node_host_prog_path = os.getenv('NVIM_NODE_HOST_PROG_PATH')
if node_host_prog_path ~= nil then
    node_host_prog_path = vim.fn.expand(node_host_prog_path)
    vim.g.node_host_prog = node_host_prog_path .. '/node'
    vim.cmd("let $PATH= '" .. node_host_prog_path .. ":' . $PATH")
end
--

-- }}}
