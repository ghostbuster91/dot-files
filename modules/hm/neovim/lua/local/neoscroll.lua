local setup = function()
    local neoscroll = require("neoscroll")
    neoscroll.setup()

    -- neoscroll dropped `neoscroll.config.set_mappings()`; custom mappings are
    -- now plain keymaps calling the helper functions with an opts table (a
    -- table argument also avoids the deprecated positional zt/zz/zb signatures).
    local modes = { "n", "v", "x" }
    local mappings = {
        ["<C-u>"] = function()
            neoscroll.ctrl_u({ duration = 250 })
        end,
        ["<C-d>"] = function()
            neoscroll.ctrl_d({ duration = 250 })
        end,
        ["zt"] = function()
            neoscroll.zt({ half_win_duration = 250 })
        end,
        ["zz"] = function()
            neoscroll.zz({ half_win_duration = 250 })
        end,
        ["zb"] = function()
            neoscroll.zb({ half_win_duration = 250 })
        end,
    }
    for key, fn in pairs(mappings) do
        vim.keymap.set(modes, key, fn, { silent = true })
    end
end

return { setup = setup }
