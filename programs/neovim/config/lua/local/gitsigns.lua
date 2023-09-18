local setup = function(next_integrations)
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            local nngs = next_integrations.gitsigns(gs)

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() nngs.next_hunk({ wrap = false }) end)
                return '<Ignore>'
            end, { expr = true })

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() nngs.prev_hunk({ wrap = false }) end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer, { desc = "git:stage buffer" })
            map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "git:undo stage hunk" })
            map('n', '<leader>hR', gs.reset_buffer, { desc = "git:reset buffer" })
            map('n', '<leader>hp', gs.preview_hunk, { desc = "git:preview hunk" })
            map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "git:blame current line" })
            map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "git:current line blame" })
            map('n', '<leader>hd', gs.diffthis, { desc = "git:show diff" })
            map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "git:show diff~" })
            map('n', '<leader>td', gs.toggle_deleted, { desc = "git:toggle deleted" })

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
    })
end

return { setup = setup }
