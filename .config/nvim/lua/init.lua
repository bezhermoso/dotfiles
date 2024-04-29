-- Allow imports from LuaRocks installation dir [[[
-- Lua 5.1:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
-- ]]]

require("core.options")
require('core.autocmds')
require('core.filetypes')
require("core.lazy")
require("core.backup")
require("core.swap")
require('core.keymaps')
