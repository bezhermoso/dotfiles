return {
    "https://github.com/ThePrimeagen/harpoon",
    lazy = true,
    keys = {
        { "<leader>ho", function() require('harpoon.ui').toggle_quick_menu() end, desc = "Harpoon: Open menu..", mode = { "n", "v" } },
        { "<leader>ha", function() require('harpoon.mark').add_file() end, desc = "Harpoon: Add current file", mode = { "n", "v" } },
        { "<leader>hr", function() require('harpoon.mark').rm_file() end, desc = "Harpoon: Remove current file", mode = { "n", "v" } },
        { "<leader>hc", function() require('harpoon.mark').clear_all() end, desc = "Harpoon: Clear", mode = { "n", "v" } },
        { "<leader>1", function() require('harpoon.ui').nav_file(1) end, desc = "Harpoon: Goto #1", mode = { "n", "v" } },
        { "<leader>2", function() require('harpoon.ui').nav_file(2) end, desc = "Harpoon: Goto #2", mode = { "n", "v" } },
        { "<leader>3", function() require('harpoon.ui').nav_file(3) end, desc = "Harpoon: Goto #3", mode = { "n", "v" } },
        { "<leader>4", function() require('harpoon.ui').nav_file(4) end, desc = "Harpoon: Goto #4", mode = { "n", "v" } },
        { "<leader>5", function() require('harpoon.ui').nav_file(5) end, desc = "Harpoon: Goto #5", mode = { "n", "v" } },
    },
    opts = {},
}
