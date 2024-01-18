-- vim.filetype.add({
--   pattern = {
--     -- TODO: Make this work.
--     ["*.yaml.template$"] = function ()
--       vim.print("You see this??! Celebrate!")
--       return "gotexttmpl.yaml"
--     end
--   }
-- })

-- YAML
vim.filetype.add({
  extension = {
    neon = "yaml",
    ["yaml.template"] = "gotexttmpl.yaml"
  },
})

-- Ruby
vim.filetype.add({
  filename = {
    Brewfile = "ruby"
  }
})

-- Terraform
vim.filetype.add({
  extension = {
    tfvars = "terraform",
  },
})
