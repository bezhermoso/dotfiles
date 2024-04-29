return {
    {
        "vhyrro/luarocks.nvim",
        priority = 1001, -- Load as early as possible
        opts = {
            rocks = {
                "magick", -- Required by 3rd/image.nvim
            },
        },
    },
}
