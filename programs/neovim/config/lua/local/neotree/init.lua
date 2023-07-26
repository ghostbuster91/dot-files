local map = vim.keymap.set

local setup = function()
    -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    vim.fn.sign_define("DiagnosticSignError",
        { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn",
        { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo",
        { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint",
        { text = "", texthl = "DiagnosticSignHint" })

    local renderer = require "neo-tree.ui.renderer"

    --- Recursively open the current folder and all folders it contains.
    local function expand_all_filesystem(state)
        local node = state.tree:get_node()
        require("neo-tree.sources.filesystem.commands").expand_all_nodes(state, node)
    end

    --- Recursively open the current folder and all folders it contains.
    local function expand_all_default(state)
        local node = state.tree:get_node()
        ---@diagnostic disable-next-line: missing-parameter
        require("neo-tree.sources.common.commands").expand_all_nodes(state, node)
    end

    local function collapse_all_under_cursor(state)
        local active_node = state.tree:get_node()
        local stack = { active_node }

        while next(stack) ~= nil do
            local node = table.remove(stack)
            local children = state.tree:get_nodes(node:get_id())
            for _, v in ipairs(children) do
                table.insert(stack, v)
            end

            if node.type == "directory" and node:is_expanded() then
                node:collapse()
            end
        end

        renderer.redraw(state)
        renderer.focus_node(state, active_node:get_id())
    end

    require("neo-tree").setup({
        git_status_async = true,
        enable_diagnostics = false,
        close_if_last_window = true,
        use_popups_for_input = false,
        filesystem = {
            scan_mode = "deep",
            async_directory_scan = "auto",
            hijack_netrw_behavior = "disabled",
            filtered_items = {
                --These filters are applied to both browsing and searching
                hide_dotfiles = false,
                hide_gitignored = false,
                never_show = {
                    ".git",
                },
            },
            window = {
                mappings = {
                    ["<C-x>"] = "clear_filter",
                    ["<bs>"] = "noop",
                    ["."] = "noop",
                    ["/"] = "noop",
                    ["<space>"] = "noop",
                    ["zO"] = expand_all_filesystem,
                },
            },
        },
        default_component_configs = {
            icon = {
                folder_empty = "󰜌",
                folder_empty_open = "󰜌",
            },
            git_status = {
                symbols = {
                    modified = "",
                    renamed  = "󰁕",
                    unstaged = "✗",
                    staged   = "✓",
                    deleted  = "",
                },
                align = "left",
            },
            name = {
                use_git_status_colors = false,
            },
        },
        window = {
            auto_expand_width = true,
            mappings = {
                ["t"] = "noop",
                ["Z"] = "noop",
                ["z"] = "none",
                ["zO"] = expand_all_default,
                ["zm"] = collapse_all_under_cursor,
            },
        },
        renderers = {
            directory = {
                { "indent" },
                { "icon" },
                { "current_filter" },
                {
                    "container",
                    content = {
                        { "name",       zindex = 10 },
                        { "clipboard",  zindex = 10 },
                        { "git_status", zindex = 10, hide_when_expanded = true },
                        {
                            "diagnostics",
                            errors_only = true,
                            zindex = 20,
                            align = "right",
                            hide_when_expanded = true
                        },
                    },
                },
            },
            file = {
                { "indent" },
                { "icon" },
                {
                    "container",
                    content = {
                        { "name",        zindex = 10 },
                        { "clipboard",   zindex = 10 },
                        { "bufnr",       zindex = 10 },
                        { "git_status",  zindex = 10 },
                        { "modified",    zindex = 20, align = "right" },
                        { "diagnostics", zindex = 20, align = "right" },
                    },
                },
            },
        },
    })
    map("n", '<leader>et', "<Cmd>:Neotree source=filesystem reveal=true position=left<CR>",
        { desc = "nvim_tree toggle" })
end

return { setup = setup }
