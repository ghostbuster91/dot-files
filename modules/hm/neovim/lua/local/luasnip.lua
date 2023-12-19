local setup = function()
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    local types = require("luasnip.util.types")
    luasnip.config.setup({
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { "●", "CmpItemKindValue" } },
                },
            },
            [types.insertNode] = {
                active = {
                    virt_text = { { "󰔶", "CmpItemKindUnit" } },
                },
            },
        },
        region_check_events = { "InsertEnter" },
    })
    local s = luasnip.snippet
    local t = luasnip.text_node

    local scalaft = "scala"

    luasnip.add_snippets(scalaft, {
        s("cats", {
            t("import cats.syntax.all._"),
        }),
    })

    luasnip.add_snippets(scalaft, {
        s("dur", {
            t("import scala.concurrent.duration._"),
        }),
    })

    luasnip.add_snippets(scalaft, {
        s("convo", {
            t("import scala.jdk.OptionConverters._"),
        }),
    })

    luasnip.add_snippets(scalaft, {
        s("convc", {
            t("import scala.jdk.CollectionConverters._"),
        }),
    })
    return luasnip
end

return {
    setup = setup,
}
