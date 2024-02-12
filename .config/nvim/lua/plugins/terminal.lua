return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function ()
            require('toggleterm').setup()
            local Terminal = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
            })
            local lazygit_toggle = function()
                lazygit:toggle()
            end
            vim.keymap.set("n", "<leader>gg", lazygit_toggle, {
                noremap = true,
                silent = true,
                desc = "Toggle lazygit term"
            })
        end
    }
}
