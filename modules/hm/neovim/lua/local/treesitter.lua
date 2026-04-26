local api = vim.api

local setup = function(next_integrations)
    -- next_integrations.treesitter_textobjects()

    require("nvim-treesitter.configs").setup({
        playground = { enable = true },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        highlight = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
            },
        },
    })
end

return { setup = setup }
