local setup = function(navic)
    local lualine = require("lualine")

    -- https://www.reddit.com/r/neovim/comments/xy0tu1/comment/irfegvd/?context=3
    local function show_macro_recording()
        local recording_register = vim.fn.reg_recording()
        if recording_register == "" then
            return ""
        else
            return "Recording @" .. recording_register
        end
    end
    vim.api.nvim_create_autocmd("RecordingEnter", {
        callback = function()
            lualine.refresh({
                place = { "statusline" },
            })
        end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
        callback = function()
            -- This is going to seem really weird!
            -- Instead of just calling refresh we need to wait a moment because of the nature of
            -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
            -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
            -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
            -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
            local timer = vim.loop.new_timer()
            timer:start(
                50,
                0,
                vim.schedule_wrap(function()
                    lualine.refresh({
                        place = { "statusline" },
                    })
                end)
            )
        end,
    })
    local function bsp_status()
        local bsp_var = vim.api.nvim_get_var("metals_bsp_status")
        if bsp_var then
            return "bsp: " .. bsp_var
        end
    end
    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {},
            always_divide_middle = true,
            globalstatus = false,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = {
                "branch",
                "diff",
                "diagnostics",
                {
                    "macro-recording",
                    fmt = show_macro_recording,
                },
            },
            lualine_c = {
                'filename',
                {
                    function()
                        return navic.get_location()
                    end,
                    cond = function()
                        return navic.is_available()
                    end
                },
            },
            lualine_x = { "encoding", "fileformat", "filetype", bsp_status },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    })
end

return { setup = setup }
