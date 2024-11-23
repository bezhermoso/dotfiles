return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = true,
                pane_gap = 10,
                sections = {
                    {
                        section = "terminal",
                        cmd = "chafa ~/Desktop/one-ring.png --format symbols --symbols vhalf --size 50x18 --stretch; sleep .1",
                        height = 18,
                        padding = 2,
                        pane = 2
                    },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status\n",
                        section = "terminal",
                        enabled = function() return Snacks.git.get_root() ~= nil end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    -- { section = "keys", gap = 1, padding = 1 },
                    { title = "Recent Files\n", section = "recent_files", indent = 2, padding = 2 },
                    { title = "Projects\n", section = "projects", indent = 2, padding = 2 },
                    { title = "Actiions\n", section = "keys", indent = 2, padding = 2 },
                },
            },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            styles = {
                notification = {
                    wo = { wrap = true } -- Wrap notifications
                }
            }
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                    "<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                end,
            })
        end,
    },
}
