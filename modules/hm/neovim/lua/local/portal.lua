local function buffer_generator(opts, settings)
    local Content = require("portal.content")
    local Iterator = require("portal.iterator")
    local Search = require("portal.search")

    local Path = require "plenary.path"
    ---@return boolean
    local function buf_in_cwd(bufname, cwd)
        if cwd:sub(-1) ~= Path.path.sep then
            cwd = cwd .. Path.path.sep
        end
        local bufname_prefix = bufname:sub(1, #cwd)
        return bufname_prefix == cwd
    end

    local bufnrs = vim.tbl_filter(function(bufnr)
        if 1 ~= vim.fn.buflisted(bufnr) then
            return false
        end
        -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            return false
        end
        if bufnr == vim.api.nvim_get_current_buf() then
            return false
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)

        if not buf_in_cwd(bufname, vim.loop.cwd()) then
            return false
        end
        return true
    end, vim.api.nvim_list_bufs())

    local buffers = {}
    for _, bufnr in ipairs(bufnrs) do
        local flag = bufnr == vim.fn.bufnr "" and "%" or (bufnr == vim.fn.bufnr "#" and "#" or " ")

        local element = {
            bufnr = bufnr,
            flag = flag,
            info = vim.fn.getbufinfo(bufnr)[1],
        }

        if (flag == "#" or flag == "%") then
            local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
            table.insert(buffers, idx, element)
        else
            table.insert(buffers, element)
        end
    end

    opts = vim.tbl_extend("force", {
        direction = "forward",
        max_results = #settings.labels,
    }, opts or {})

    if settings.max_results then
        opts.max_results = math.min(opts.max_results, settings.max_results)
    end

    -- stylua: ignore
    local iter = Iterator:new(buffers)
        :take(settings.lookback)

    if opts.start then
        iter = iter:start_at(opts.start)
    end
    if opts.direction == Search.direction.backward then
        iter = iter:reverse()
    end

    iter = iter:map(function(v, _)
        return Content:new({
            type = "recent buffers",
            buffer = v.bufnr,
            cursor = { row = v.info.lnum, col = 1 },
            callback = function(content)
                vim.api.nvim_win_set_buf(0, content.buffer)
                vim.api.nvim_win_set_cursor(0, { content.cursor.row, content.cursor.col })
            end,
        })
    end)

    iter = iter:filter(function(v)
        return vim.api.nvim_buf_is_valid(v.buffer)
    end)
    if settings.filter then
        iter = iter:filter(settings.filter)
    end
    if opts.filter then
        iter = iter:filter(opts.filter)
    end
    if not opts.slots then
        iter = iter:take(opts.max_results)
    end

    return {
        source = iter,
        slots = opts.slots,
    }
end


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

    local query = function(opts)
        local Settings = require("portal.settings")
        return buffer_generator(opts or {}, Settings)
    end

    vim.keymap.set('n', '<BS>n', function()
        portal.tunnel(query({ max_results = 5 }))
    end)
end

return {
    setup = setup,
}
