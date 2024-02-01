local map = vim.keymap.set

local setup = function(diffview)
    local actions = require("telescope.actions")
    local telescope = require("telescope")
    local previewers = require("telescope.previewers")
    local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
    local action_state = require("telescope.actions.state")
    local utils = require("telescope.utils")

    local small_files_preview_maker = function(filepath, bufnr, opts)
        opts = opts or {}

        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
            if not stat then
                return
            end
            if stat.size > 100000 then
                return
            else
                previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
        end)
    end
    telescope.setup({
        defaults = {
            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 15,
                },
                -- other layout configuration
            },
            buffer_previewer_maker = small_files_preview_maker,
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
                    },
                },
            },
            git_bcommits = {
                mappings = {
                    i = {
                        ["<CR>"] = function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            if selection == nil then
                                utils.__warn_no_selection("builtin.commands")
                                return
                            end
                            actions.close(prompt_bufnr)
                            diffview.open(selection.value .. "~1..." .. selection.value)
                        end,
                    },
                },
            },
            commands = {
                mappings = {
                    i = {
                        ["<CR>"] = function(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            local val = selection.value
                            local cmd = string.format([[:%s ]], val.name)

                            vim.cmd(cmd)
                            vim.fn.histadd("cmd", val.name)
                        end,
                        ["<S-CR>"] = function(prompt_bufnr) -- original behavior
                            local selection = action_state.get_selected_entry()
                            if selection == nil then
                                utils.__warn_no_selection("builtin.commands")
                                return
                            end

                            actions.close(prompt_bufnr)
                            local val = selection.value
                            local cmd = string.format([[:%s ]], val.name)

                            if val.nargs == "0" then
                                vim.cmd(cmd)
                                vim.fn.histadd("cmd", val.name)
                            else
                                vim.cmd([[stopinsert]])
                                vim.fn.feedkeys(cmd, "n")
                            end
                        end,
                    },
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown({
                    -- even more opts
                }),
                undo = {
                    use_delta = false,
                },
            },
        },
    })

    local builtin = require("telescope.builtin")
    map("n", "<Leader>/", builtin.commands, { noremap = true, desc = "show commands" })
    map("n", "<Leader>gwd", function()
        builtin.diagnostics({ layout_strategy = "vertical" })
    end, { desc = "diagnostics" })

    map("n", "<leader>ec", function()
        builtin.git_bcommits()
    end, { desc = "Buffer commites" })
    map("n", "<leader>ti", function()
        telescope.extensions.live_grep_args.live_grep_args({ layout_strategy = "vertical" })
    end, { desc = "Live grep" })
    map("v", "<leader>ti", function()
        live_grep_args_shortcuts.grep_word_under_cursor({ layout_strategy = "vertical" })
    end, { desc = "Grep string" })
    map("n", "<leader>gh", builtin.git_commits, { desc = "Commites" })
    map("n", "<leader>ts", builtin.git_status, { desc = "Git status" })
    map("n", "<leader>tf", builtin.git_files, { desc = "Git files" })
    map("n", "<leader>tt", builtin.find_files, { desc = "Files" })
    map("n", "<leader>th", function()
        builtin.buffers({ sort_mru = true, layout_strategy = "vertical" })
    end, { desc = "Buffers" })
    map("n", "<leader>hh", builtin.help_tags, { desc = "Help tags" })
    map("n", "<leader>tr", builtin.resume, { desc = "Telescope resume" })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("undo")
    telescope.load_extension("live_grep_args")

    map("n", "<leader>u", "<cmd>Telescope undo<cr>")
    return {
        core = telescope,
        builtin = builtin,
    }
end

return { setup = setup }
