local M = {}
local theta = require('alpha.themes.theta')

M.alpha_config = function()
    local requirements_str = {}

    if vim.fn.executable('fortune') == 0 then
        table.insert(requirements_str, "fortune is not installed. Run `brew install fortune`")
    end

    if vim.fn.executable('boxes') == 0 then
        table.insert(requirements_str, "boxes is not installed. Run `brew install boxes`")
    end

    if vim.fn.executable('lolcrab') == 0 then
        table.insert(requirements_str, "lolcrab is not installed. Run `cargo install lolcrab`")
    end

    if #requirements_str > 0 then
        theta.header.type = "text"
        theta.header.val = requirements_str
        return theta.config
    end

    theta.header.type = "group"
    theta.header.val = {
        {
            type = "terminal",
            command = table.concat({
                [[paste]],
                [[~/.dotfiles/ascii/block-logo-ascii.txt]],
                [[ =( ]],
                [[ echo; echo; echo; echo; ]], -- Top padding
                [[ fortune -s dune dune-messiah ]],
                [[ | fold -w 50 -s ]],
                [[ | boxes -d java-cmt -p l2 ]],
                [[ | lolcrab --custom '\#FFB89C' '\#FF9261' '\#FF4F00' '\#8FF8EC' '\#2ED7C8' '\#13BBAF' ]], -- Block branding colors
                [[ ) ]],
            }, " "),
            width = 100,
            height = 17,
            opts = {
                position = "center",
                redraw = true,
                window_config = {},
            },
        },
    }
    return theta.config
end

return M
