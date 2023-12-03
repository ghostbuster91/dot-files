local setup = function(next_integrations)
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local prefix_key = '<leader>h'

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            local nngs = next_integrations.gitsigns(gs)

            -- Navigation
            map({ 'n', 'v', 'o' }, ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() nngs.next_hunk({ wrap = false }) end)
                return '<Ignore>'
            end, { expr = true })

            map({ 'n', 'v', 'o' }, '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() nngs.prev_hunk({ wrap = false }) end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map({ 'n', 'v' }, prefix_key .. 's', ':Gitsigns stage_hunk<CR>')
            map({ 'n', 'v' }, prefix_key .. 'r', ':Gitsigns reset_hunk<CR>')
            map('n', prefix_key .. 'S', gs.stage_buffer, { desc = "git:stage buffer" })
            map('n', prefix_key .. 'u', gs.undo_stage_hunk, { desc = "git:undo stage hunk" })
            map('n', prefix_key .. 'R', gs.reset_buffer, { desc = "git:reset buffer" })
            map('n', prefix_key .. 'p', gs.preview_hunk, { desc = "git:preview hunk" })
            map('n', prefix_key .. 'b', function() gs.blame_line { full = true } end, { desc = "git:blame current line" })
            -- map('n', '<leader>hd', gs.diffthis, { desc = "git:show diff" })
            -- map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "git:show diff~" })

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
    })
end

return { setup = setup }
