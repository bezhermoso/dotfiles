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
