-- vim.filetype.add({
--   pattern = {
--     -- TODO: Make this work.
--     ["*.yaml.template$"] = function ()
--       vim.print("You see this??! Celebrate!")
--       return "gotexttmpl.yaml"
--     end
--   }
-- })

vim.filetype.add({
  extension = {
    neon = "yaml",
    ["yaml.template"] = "gotexttmpl.yaml"
  },
  filename = {
    Brewfile = "ruby"
  }
})
