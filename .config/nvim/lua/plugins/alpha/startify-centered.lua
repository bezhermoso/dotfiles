local startify = require("alpha.themes.startify")

local wrap_results_func = function(func)
    return function()
        local results = func()
        for i, res in ipairs(results) do
            if res.type == "group" then
                results[i].opts = {
                    position = "center"
                }
                for j, v in ipairs(res.val) do
                    results[i].val[j].opts = vim.tbl_extend("force", v.opts, {
                        position = "center",
                        align_shortcut = "right",
                        width = 80,
                        cursor = 77,
                    })
                end
            end
        end
        return {
            {
                type = "group",
                val = results,
                opts = {
                    position = "center",
                    width = 100,
                    computed = true,
                }
            }
        }
    end
end

local recursively_center
recursively_center = function(elements)
    if type(elements) == "function" then
        return wrap_results_func(elements)
    end
    for k, el in ipairs(elements) do
        el.opts = el.opts or {}
        el.opts.position = "center"
        if el.type == "group" then
            el.val = recursively_center(el.val)
        end
        elements[k] = el
    end
    return elements
end

local M = startify
M.config.layout = recursively_center(M.config.layout)
return M
