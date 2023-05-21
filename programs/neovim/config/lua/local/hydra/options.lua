local diag = vim.diagnostic


local setup = function(hydra, lsp)
    local M = {}
    M.virtual_text = function()
        if lsp.virtual_text.enabled then
            return '[x]'
        else
            return '[ ]'
        end
    end
    M.auto_format = function()
        if lsp.auto_format.enabled then
            return '[x]'
        else
            return '[ ]'
        end
    end
    M.spell_check = function()
        if lsp.spell_check.enabled then
            return '[x]'
        else
            return '[ ]'
        end
    end
    local hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters
  _s_ %{spell_check} null_ls spell check
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  _j_ %{virtual_text} virtual text
  _f_ %{auto_format} auto format
  ^
       ^^^^                _<Esc>_
]]

    hydra({
        name = 'Options',
        hint = hint,
        config = {
            color = 'amaranth',
            invoke_on_body = true,
            hint = {
                border = 'rounded',
                position = 'middle',
                funcs = {
                    virtual_text = M.virtual_text,
                    auto_format = M.auto_format,
                    spell_check = M.spell_check,
                },
            }
        },
        mode = { 'n', 'x' },
        body = '<leader>v',
        heads = {
            { 'n', function()
                if vim.o.number == true then
                    vim.o.number = false
                else
                    vim.o.number = true
                end
            end, { desc = 'number' } },
            { 'r', function()
                if vim.o.relativenumber == true then
                    vim.o.relativenumber = false
                else
                    vim.o.number = true
                    vim.o.relativenumber = true
                end
            end, { desc = 'relativenumber' } },
            { 'v', function()
                if vim.o.virtualedit == 'all' then
                    vim.o.virtualedit = 'block'
                else
                    vim.o.virtualedit = 'all'
                end
            end, { desc = 'virtualedit' } },
            { 'i', function()
                if vim.o.list == true then
                    vim.o.list = false
                else
                    vim.o.list = true
                end
            end, { desc = 'show invisible' } },
            { 's', function()
                lsp.spell_check.toggle()
            end, { exit = true, desc = 'null_ls spell check' } },
            { 'w', function()
                if vim.o.wrap ~= true then
                    vim.o.wrap = true
                    -- Dealing with word wrap:
                    -- If cursor is inside very long line in the file than wraps
                    -- around several rows on the screen, then 'j' key moves you to
                    -- the next line in the file, but not to the next row on the
                    -- screen under your previous position as in other editors. These
                    -- bindings fixes this.
                    vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
                        { expr = true, desc = 'k or gk' })
                    vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
                        { expr = true, desc = 'j or gj' })
                else
                    vim.o.wrap = false
                    vim.keymap.del('n', 'k')
                    vim.keymap.del('n', 'j')
                end
            end, { desc = 'wrap' } },
            { 'c', function()
                if vim.o.cursorline == true then
                    vim.o.cursorline = false
                else
                    vim.o.cursorline = true
                end
            end, { desc = 'cursor line' } },
            { 'j', function()
                lsp.virtual_text.toggle()
            end, { exit = true, desc = "toggle virtual text" } },
            { 'f', function()
                lsp.auto_format.toggle()
            end, { exit = true, desc = "toggle auto format" } },
            { '<Esc>', nil, { exit = true } }
        }
    })
end

return { setup = setup }
