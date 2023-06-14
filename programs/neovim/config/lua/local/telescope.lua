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

    map("n", "<leader>hc", function()
        require("telescope.builtin").git_bcommits()
    end, { desc = "Buffer commites" })
    map("n", "<leader>tg", function()
        require("telescope.builtin").live_grep({ layout_strategy = "vertical" })
    end, { desc = "Live grep" })

    map("n", "<leader>gh", function()
        require("telescope.builtin").git_commits()
    end, { desc = "Commites" })
    map("n", "<leader>tf", function()
        require("telescope.builtin").find_files()
    end, { desc = "Files" })
    map("n", "<leader>th", function()
        require("telescope.builtin").buffers()
    end, { desc = "Buffers" })


    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("undo")
    map("n", "<leader>u", "<cmd>Telescope undo<cr>")
    return {
        core = telescope,
        builtin = telescope_builtin
    }
end

return { setup = setup }
