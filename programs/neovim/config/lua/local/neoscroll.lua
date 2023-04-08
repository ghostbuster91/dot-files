local setup = function()
    require('neoscroll').setup()
    local t    = {}
    t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '250' } }
    t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '250' } }
    t['zt']    = { 'zt', { '250' } }
    t['zz']    = { 'zz', { '250' } }
    t['zb']    = { 'zb', { '250' } }
    require('neoscroll.config').set_mappings(t)
end

return { setup = setup }
