local map = vim.keymap.set

local setup = function(next_integrations)
    local diffview_actions = next_integrations.diffview(require("diffview.actions"))
    local diffview = require("diffview")
    diffview.setup({
        keymaps = {
            view = {
                { "n", "[x", diffview_actions.prev_conflict,
                    { desc = "In the merge-tool: jump to the previous conflict" }
                },
                { "n", "]x", diffview_actions.next_conflict,
                    { desc = "In the merge-tool: jump to the next conflict" }
                },
                { "n", "q", function() diffview.close() end, { desc = "Close diffview" } },
            },
            file_panel = {
                { "n", "q",     function() diffview.close() end, { desc = "Close diffview" } },
                { "n", "<ESC>", function() diffview.close() end, { desc = "Close diffview" } },
            },
            file_history_panel = {
                { "n", "q",     function() diffview.close() end, { desc = "Close diffview" } },
                { "n", "<ESC>", function() diffview.close() end, { desc = "Close diffview" } },
            }
        }
    })
    map("n", "<leader>ef", function()
        diffview.open({ "--", "%" })
    end, { desc = "Open current file diff" })
    map("n", "<leader>ep", function()
        diffview.open({})
    end, { desc = "Open diff" })

    return diffview
end

return { setup = setup }
