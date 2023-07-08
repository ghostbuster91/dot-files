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
        pickers = {
            buffers = {
                mappings = {
                    i = {
                        ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                    }
                }
            }
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

    local builtin = require('telescope.builtin')
    map("n", "<Leader>/", builtin.commands, { noremap = true, desc = "show commands" })
    map(
        "n",
        "<Leader>gwd",
        function()
            builtin.diagnostics({ layout_strategy = "vertical" })
        end,
        { desc = "diagnostics" }
    )

    map("n", "<leader>hc", function()
        builtin.git_bcommits()
    end, { desc = "Buffer commites" })
    map("n", "<leader>tg", function()
        builtin.live_grep({ layout_strategy = "vertical" })
    end, { desc = "Live grep" })
    map("n", "<leader>gh", builtin.git_commits, { desc = "Commites" })
    map("n", "<leader>ts", builtin.git_status, { desc = "Git status" })
    map("n", "<leader>tf", builtin.git_files, { desc = "Git files" })
    map("n", "<leader>tt", builtin.find_files, { desc = "Files" })
    map("n", "<leader>th", function()
        builtin.buffers({ sort_mru = true })
    end, { desc = "Buffers" })
    map('n', '<leader>hh', builtin.help_tags, { desc = "Help tags" })
    map('n', '<leader>tr', builtin.resume, { desc = "Telescope resume" })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("undo")
    map("n", "<leader>u", "<cmd>Telescope undo<cr>")
    return {
        core = telescope,
        builtin = builtin
    }
end

return { setup = setup }
