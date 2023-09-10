local setup = function()
    -- luasnip setup
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    local types = require("luasnip.util.types")
    luasnip.config.setup({
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "●", "CmpItemKindValue" } }
                }
            },
            [types.insertNode] = {
                active = {
                    virt_text = { { "󰔶", "CmpItemKindUnit" } }
                }
            }
        },
        region_check_events = { 'InsertEnter' },
    })

    -- nvim-cmp setup
    local lspkind = require("lspkind")
    local cmp = require("cmp")
    local compare = require('cmp.config.compare')
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            }),
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<S-CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            ["<S-Tab>"] = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
        },
        sources = {
            { name = "nvim_lsp", priority = 10 },
            { name = "buffer",   priority = 9 },
            { name = "luasnip",  priority = 8 },
            { name = "path",     priority = 5 },
        },
        preselect = cmp.PreselectMode.None, -- disable preselection
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.offset,    -- we still want offset to be higher to order after 3rd letter
                compare.score,     -- same as above
                compare.sort_text, -- add higher precedence for sort_text, it must be above `kind`
                compare.recently_used,
                compare.kind,
                compare.length,
                compare.order,
            },
        },
        -- if you want to add preselection you have to set completeopt to new values
        completion = {
            -- completeopt = 'menu,menuone,noselect', <---- this is default value,
            completeopt = 'menu,menuone', -- remove noselect
        },
    })
    return cmp
end

return { setup = setup }
