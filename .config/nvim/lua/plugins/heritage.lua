return {
    -- https://github.com/jessarcher/vim-heritage
    "jessarcher/vim-heritage",
    keys = {
        -- Replaces the built-in gf mapping with a version that can handle non-existent files.
        -- Together with vim-heritage, this allows you to open non-existent files even if they're in
        -- a non-existing direectory. The plugin will create the directory heirarchy for you.
        {"gf", ":edit %:h/<cfile><CR>", desc = "Edit file under cursor"}
    }
}
