local api = vim.api

local setup = function(next_integrations)
    next_integrations.treesitter_textobjects()

    -- highlights for treesitter-refactor
    vim.api.nvim_set_hl(0, 'TSDefinition', { bg = '#2A2A37' })
    vim.api.nvim_set_hl(0, 'TSDefinitionUsage', { bg = '#2A2A37' })

    require("nvim-treesitter.configs").setup({
        ensure_installed = {},
        highlight = {
            enable = true, -- false will disable the whole extension                 -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
            disable = function(_, bufnr) -- Disable in large buffers
                return api.nvim_buf_line_count(bufnr) > 50000
            end,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
                scope_incremental = "<TAB>",
            },
        },
        textobjects = {
            enable = true,
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            },
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    -- You can also use captures from other query groups like `locals.scm`
                    ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                },
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'V',  -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                include_surrounding_whitespace = false,
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<cr>',
                show_help = '?',
            },
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        nvim_next = {
            enable = true,
            textobjects = {
                move = {
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                }
            }
        },
        refactor = {
            enable = true,
            highlight_definitions = {
                enable = true,
                -- Set to false if you have an `updatetime` of ~100.
                clear_on_cursor_move = true,
            },
            highlight_current_scope = { enable = false },
            navigation = {
                enable = true,
                -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
                keymaps = {
                    goto_definition = false,
                    list_definitions = false,
                    list_definitions_toc = false,
                    goto_next_usage = ")",
                    goto_previous_usage = "(",
                },
            },
        },
    })
end

return { setup = setup }
