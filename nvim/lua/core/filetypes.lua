vim.filetype.add({
  pattern = {
    -- TODO: Make this work.
    ["*.yaml.template$"] = function ()
      vim.print("You see this??! Celebrate!")
      return "gotexttmpl.yaml"
    end
  }
})
