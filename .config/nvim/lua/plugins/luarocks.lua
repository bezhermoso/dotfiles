-- Allow imports from LuaRocks installation dir [[[
-- Lua 5.1:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
-- ]]]

return {
    {
        -- https://github.com/vhyrro/luarocks.nvim
        "vhyrro/luarocks.nvim",
        priority = 1001, -- Load as early as possible
        opts = {
            rocks = {
                "magick", -- Required by 3rd/image.nvim
            },
        },
    },
}
