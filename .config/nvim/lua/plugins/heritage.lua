return {
    -- https://github.com/jessarcher/vim-heritage
    "jessarcher/vim-heritage",
    keys = {
        {"gf", function ()
            local path = vim.fn.expand("<cfile>")
            if vim.fn.filereadable(vim.fn.expand(path)) == 1 then
                vim.cmd("edit " .. path)
            else
                vim.cmd(":edit %:h/" .. path)
            end
        end, desc = "Edit file under cursor", noremap = true },
        -- Replaces the built-in gf mapping with a version that can handle non-existent files.
        -- Together with vim-heritage, this allows you to open non-existent files even if they're in
        -- a non-existing direectory. The plugin will create the directory heirarchy for you.
        -- {"gf", ":edit %:h/<cfile><CR>", desc = "Edit file under cursor"}
    }
}
