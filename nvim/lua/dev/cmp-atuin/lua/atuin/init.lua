local M = {}  
local source = {}

---Return whether this source is available in the current context or not (optional).
---@return boolean
function source:is_available()
  return true
end

---Return the debug name of this source (optional).
---@return string
function source:get_debug_name()
  return 'cmp-atuin'
end

---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
  return { '!', '`' }
end

---Invoke completion (required).
---@param request cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset)
    --print('cmp-atuin: input: ' .. input)
    if not vim.startswith(input, '!') and not vim.startswith('`', input) then
        callback({})
        return
    end
    --print(vim.inspect(request))
    local handle = io.popen('atuin search "^' .. input .. '" --format="<<<{command}>>>"')
    if not handle then
        vim.notify('cmp-atuin: atuin search failed', vim.logs.levels.ERROR)
        callback({})
        return
    end
    local items = {}
    local lines = handle:lines()
    -- TODO: Support multi-line commands. They span multiple lines in the output.
    for line in lines do
        if vim.startswith(line, '<<<') and vim.endswith(line, '>>>') then
            local lpos = string.find(line, '<<<')
            local rpos = string.find(line, '>>>')
            local cmd = string.sub(line, lpos + 3, rpos - 1)
            table.insert(items, {
                label = cmd,
                filterText = cmd,
            })
        end
        -- if current_cmd ~= "" and is_waiting_to_close and vim.startswith(line, '[[[') then
        --     table.insert(items, {
        --         label = current_cmd,
        --     })
        --     local tpos = string.find('\t', line)
        --     if tpos then
        --         current_cmd = string.sub(line, tpos, nil)
        --     end
        -- end
    end
    callback({
        items = items,
        isIncomplete = true,
    })
    handle:close()
end

---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
-- function source:resolve(completion_item, callback)
--   callback(completion_item)
-- end

---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
-- function source:execute(completion_item, callback)
--   callback(completion_item)
-- end


M.setup = function()
    require('cmp').register_source('atuin', source)
end

return M
