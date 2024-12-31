local cmp = require("cmp")
local luasnip = require("luasnip")

local M = {}

-- Super-Tab like snippet expansion. 
-- Taken from: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
-- However, we will use C-n & C-p, but definitely using the awareness between completion & snippets.
--
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.next_cmp_item = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
        -- that way you will only jump inside the snippet region
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end, { "i", "s" })

M.prev_cmp_item = cmp.mapping(function(fallback)
    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
    else
        fallback()
    end
end, { "i", "s" })

return M
