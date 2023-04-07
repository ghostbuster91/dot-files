local map = vim.keymap.set

local setup = function()
    local actions = require("telescope.actions")
    local telescope = require("telescope")
    telescope.setup({
        defaults = {
            mappings = {
                n = {
                    ["f"] = actions.send_to_qflist,
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- even more opts
                },
                undo = {
                    use_delta = false,
                }
            }
        }
    })

    local telescope_builtin = require('telescope.builtin')
    map("n", "<Leader>/", telescope_builtin.commands, { noremap = true, desc = "show commands" })
    map(
        "n",
        "<Leader>gwd",
        function()
            telescope_builtin.diagnostics({ layout_strategy = "vertical" })
        end,
        { desc = "diagnostics" }
    )


    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    return telescope
end

return { setup = setup }
