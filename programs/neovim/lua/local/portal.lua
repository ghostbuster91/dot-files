local setup = function()
    local portal = require("portal")
    portal.setup({
        ---@type "debug" | "info" | "warn" | "error"
        log_level = "warn",

        ---The base filter applied to every search.
        ---@type Portal.SearchPredicate | nil
        filter = nil,

        ---The maximum number of results for any search.
        ---@type integer | nil
        max_results = nil,

        ---The maximum number of items that can be searched.
        ---@type integer
        lookback = 100,

        ---An ordered list of keys for labelling portals.
        ---Labels will be applied in order, or to match slotted results.
        ---@type string[]
        labels = { "n", "e", "i", "o", "t", "s", "r", "a" },

        ---Select the first portal when there is only one result.
        select_first = false,

        ---Keys used for exiting portal selection. Disable with [{key}] = false
        ---to `false`.
        ---@type table<string, boolean>
        escape = {
            ["<esc>"] = true,
        },

        ---The raw window options used for the portal window
        window_options = {
            relative = "cursor",
            width = 80,
            height = 5,
            col = 2,
            focusable = false,
            border = "single",
            noautocmd = true,
        },
    })

    ---@type Portal.QueryGenerator
    local function generate(opts, settings)
        local opts = {}
        local filter = vim.tbl_filter
        local bufnrs = filter(function(b)
            if 1 ~= vim.fn.buflisted(b) then
                return false
            end
            -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
            if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
                return false
            end
            if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
                return false
            end
            if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
                return false
            end
            if not opts.cwd_only and opts.cwd and not string.find(vim.api.nvim_buf_get_name(b), opts.cwd, 1, true) then
                return false
            end
            return true
        end, vim.api.nvim_list_bufs())
        if not next(bufnrs) then
            return
        end
        if opts.sort_mru then
            table.sort(bufnrs, function(a, b)
                return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
            end)
        end

        local buffers = {}
        local default_selection_idx = 1
        for _, bufnr in ipairs(bufnrs) do
            local flag = bufnr == vim.fn.bufnr "" and "%" or (bufnr == vim.fn.bufnr "#" and "#" or " ")

            if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
                default_selection_idx = 2
            end

            local element = {
                bufnr = bufnr,
                flag = flag,
                info = vim.fn.getbufinfo(bufnr)[1],
            }

            if opts.sort_lastused and (flag == "#" or flag == "%") then
                local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
                table.insert(buffers, idx, element)
            else
                table.insert(buffers, element)
            end
        end

        local Content = require("portal.content")
        local Iterator = require("portal.iterator")

        local iter = Iterator:new(buffers)
            :take(100)

        iter = iter:map(function(v, _)
            return Content:new({
                type = "buffers",
                buffer = v.bufnr,
                cursor = { row = v.info.lnum, col = 0 },
                callback = function(content)
                    vim.api.nvim_win_set_buf(0, content.buffer)
                    vim.api.nvim_win_set_cursor(0, { content.cursor.row, content.cursor.col })
                end,
            })
        end)

        iter = iter:filter(function(v)
            return vim.api.nvim_buf_is_valid(v.buffer) and v.buffer ~= vim.fn.bufnr()
        end)

        return {
            source = iter,
            slots = opts.slots,
        }
    end


    local query = function(opts)
        local Settings = require("portal.settings")
        return generate(opts or {}, Settings)
    end

    vim.keymap.set('n', '<BS>n', function()
        portal.tunnel(query({ max_results = 5 }))
    end)
end

return {
    setup = setup
}
