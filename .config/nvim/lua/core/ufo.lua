local M = {}

local keyamp_desc = "LSP/Folding: LSP lookup or preview folded range"

-- Defines the LSP-or-fold binding for a "key" entry in a lazy.nvim plugin spec.
local peek_or_lsp_hover = function()
  local _, ok = pcall(require, "ufo")
  if ok then
    local win_id = require("ufo").peekFoldedLinesUnderCursor()
    if win_id then
      -- If ufo was able to peek at folded range, terminate early.
      return
    end
  end
  -- Fallback to LSP lookup float window.
  vim.lsp.buf.hover()
end

M.lazy_mapping = function ()
  return {
    "K",
    peek_or_lsp_hover,
    {
      desc = keyamp_desc,
    }
  }
end

-- Binds LSP-or-fold binding from inside LSP on_attach callback.
M.lsp_on_attach_mapping = function()
  vim.keymap.set('n', 'K', peek_or_lsp_hover, { desc = keyamp_desc })
end


return M
