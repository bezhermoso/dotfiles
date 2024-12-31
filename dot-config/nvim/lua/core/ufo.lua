local M = {}

-- Defines the LSP-or-fold binding for a "key" entry in a lazy.nvim plugin spec.
M.peek_or_lsp_hover = function()
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

return M
