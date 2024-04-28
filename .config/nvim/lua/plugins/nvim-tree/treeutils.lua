-- Taken from https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope
--
local api = require("nvim-tree.api")
local M = {}

-- This cause an error: might be due to auto-closing nvim-tree config that I have in place.
-- 
-- local view_selection = function(prompt_bufnr, map)
--   actions.select_default:replace(function()
--     actions.close(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     local filename = selection.filename
--     if (filename == nil) then
--       filename = selection[1]
--     end
--     openfile.fn('preview', filename)
--   end)
--   return true
-- end

function M.launch_live_grep(opts)
  return M.launch_telescope("live_grep", opts)
end

function M.launch_find_files(opts)
  return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
  local telescope_status_ok, _ = pcall(require, "telescope")
  if not telescope_status_ok then
    return
  end
  local node = api.tree.get_node_under_cursor()
  local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
  local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
  if (node.name == '..' and TreeExplorer ~= nil) then
    basedir = TreeExplorer.cwd
  end
  opts = opts or {}
  opts.cwd = basedir
  opts.search_dirs = { basedir }
  -- Omitting this from the original article; Telescope's default action on select works just fine.
  -- opts.attach_mappings = view_selection
  return require("telescope.builtin")[func_name](opts)
end

return M
