return {
    {
        -- https://github.com/nvim-pack/nvim-spectre
        "nvim-pack/nvim-spectre",
        cmd = {"Spectre"},
        keys = {
            { "<leader>S", function() require("spectre").toggle() end, {
                desc = "Spectre: Toggle",
            } },
            { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, {
                desc = "Spectre: Open w/ word under cursor",
            } },
            { "<leader>sw", function() require("spectre").open_visual() end, {
                desc = "Spectre: Search word under cursor",
                mode = "v"
            } },
            { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, {
                desc = "Spectre: Search word in file",
                mode = "v"
            } },
        }
    }
}
