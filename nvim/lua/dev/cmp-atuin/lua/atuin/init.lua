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
    if not vim.startswith(input, '!') and not vim.startswith('`', input) then
        callback({})
        return
    end
    local handle = io.popen('atuin search "^' .. input .. '" --format="[[[\t{command}\t]]]"')
    if not handle then
        vim.notify('cmp-atuin: atuin search failed', vim.logs.levels.ERROR)
        callback({})
        return
    end
    local items = {}
    local lines = handle:lines()


    local default_option = {
        replace_trigger_chars = { "!" }
    }

    local trigger_char = request.completion_context.triggerCharacter
    local opts = (request.option == nil and default_option or request.option)

    local replace_trigger_char = false
    print(vim.inspect(opts))
    if opts and opts.replace_trigger_chars then
        for _, v in ipairs(opts.replace_trigger_chars) do
            if v == trigger_char then
                replace_trigger_char = true
            end
        end
    end


    -- TODO: Support multi-line commands. They span multiple lines in the output.
    for line in lines do
        local lpos = string.find(line, '%[%[%[\t')
        local rpos = string.find(line, '\t]%]%]$')
        if lpos == 1 and rpos ~= nil then
            local cmd = string.sub(line, lpos + 4, rpos - 1)

            local textEdit = nil

            if replace_trigger_char then
                textEdit = {
                    newText = cmd,
                    range = {
                        start = {
                            line = request.context.cursor.row - 1,
                            character = request.context.cursor.col - 2 - #input,
                        },
                        ['end'] = {
                            line = request.context.cursor.row - 1,
                            character = request.context.cursor.col - 2,
                        }
                    }
                }
            end
            table.insert(items, {
                label = cmd,
                filterText = cmd,
                textEdit = textEdit,
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

M.setup = function()
    require('cmp').register_source('atuin', source)
end

return M
