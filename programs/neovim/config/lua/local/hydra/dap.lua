local map = vim.keymap.set

local setup = function(hydra, lsp)
    local hint = [[
 _n_: step over   _s_: Continue/Start   _t_: Breakpoint     _K_: Eval
 _i_: step into   _x_: Quit             _b_: Breakpoint     _r_: toggle repl
 _o_: step out    _X_: Stop             _l_: run last
 _c_: to cursor   _u_: toggle UI
 ^
 ^ ^              _q_: exit
]]
    table.insert(lsp.on_attach_dap_subscribers, {
        on_attach = function(_, bufnr, dap)
            -- based on https://github.com/anuvyklack/hydra.nvim/issues/3#issuecomment-1162988750
            local dap_hydra = hydra({
                hint = hint,
                config = {
                    color = 'pink',
                    invoke_on_body = true,
                    hint = {
                        position = 'bottom',
                        border = 'rounded'
                    },
                },
                name = 'dap',
                mode = { 'n', 'x' },
                body = '<leader>dh',
                heads = {
                    { 'n', dap.step_over,     { silent = true } },
                    { 'i', dap.step_into,     { silent = true } },
                    { 'o', dap.step_out,      { silent = true } },
                    { 'c', dap.run_to_cursor, { silent = true } },
                    { 's', dap.continue,      { silent = true } },
                    { 'x', dap.terminate, {
                        exit = true,
                        silent = true
                    } },
                    { 'X', dap.close,             { silent = true } },
                    { 'u', dap.toggle_ui,         { silent = true } },
                    { 't', dap.toggle_breakpoint, { silent = true } },
                    { 'b', dap.set_breakpoint,    { silent = true } },
                    { 'l', dap.run_last,          { silent = true } },
                    { 'K', dap.hover,             { silent = true } },
                    { 'r', dap.hover,             { silent = true } },
                    { 'q', nil, {
                        exit = true,
                        nowait = true
                    } },
                }
            })

            hydra.spawn = function(head)
                if head == 'dap-hydra' then
                    dap_hydra:activate()
                end
            end

            map({ 'n' }, "<leader>da", function()
                dap.continue()
                hydra.spawn('dap-hydra')
            end, { buffer = bufnr, desc = "Attach debugger" })
        end

    })
end

return { setup = setup }
