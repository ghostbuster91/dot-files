local map = vim.keymap.set

local setup = function()
    -- Unless you are still migrating, remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

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
    -- Expand a node and load filesystem info if needed.
    local function open_dir(state, dir_node)
        local fs = require "neo-tree.sources.filesystem"
        fs.toggle_directory(state, dir_node, nil, true, false)
    end

    -- Expand a node and all its children, optionally stopping at max_depth.
    local function recursive_open(state, node, max_depth)
        local max_depth_reached = 1
        local stack = { node }
        while next(stack) ~= nil do
            node = table.remove(stack)
            if node.type == "directory" and not node:is_expanded() then
                open_dir(state, node)
            end

            local depth = node:get_depth()
            max_depth_reached = math.max(depth, max_depth_reached)

            if not max_depth or depth < max_depth - 1 then
                local children = state.tree:get_nodes(node:get_id())
                for _, v in ipairs(children) do
                    table.insert(stack, v)
                end
            end
        end

        return max_depth_reached
    end


    --- Open the fold under the cursor, recursing if count is given.
    local function neotree_zo(state, open_all)
        local node = state.tree:get_node()

        if open_all then
            recursive_open(state, node)
        else
            recursive_open(state, node, node:get_depth() + vim.v.count1)
        end

        renderer.redraw(state)
    end

    --- Recursively open the current folder and all folders it contains.
    local function neotree_zO(state)
        neotree_zo(state, true)
    end

    -- The nodes inside the root folder are depth 2.
    local MIN_DEPTH = 2

    --- Close the node and its parents, optionally stopping at max_depth.
    local function recursive_close(state, node, max_depth)
        if max_depth == nil or max_depth <= MIN_DEPTH then
            max_depth = MIN_DEPTH
        end

        local last = node
        while node and node:get_depth() >= max_depth do
            if node:has_children() and node:is_expanded() then
                node:collapse()
            end
            last = node
            node = state.tree:get_node(node:get_parent_id())
        end

        return last
    end

    --- Close a folder, or a number of folders equal to count.
    local function neotree_zc(state, close_all)
        local node = state.tree:get_node()
        if not node then
            return
        end

        local max_depth
        if not close_all then
            max_depth = node:get_depth() - vim.v.count1
            if node:has_children() and node:is_expanded() then
                max_depth = max_depth + 1
            end
        end

        local last = recursive_close(state, node, max_depth)
        renderer.redraw(state)
        renderer.focus_node(state, last:get_id())
    end

    -- Close all containing folders back to the top level.
    local function neotree_zC(state)
        neotree_zc(state, true)
    end

    --- Open a closed folder or close an open one, with an optional count.
    local function neotree_za(state, toggle_all)
        local node = state.tree:get_node()
        if not node then
            return
        end

        if node.type == "directory" and not node:is_expanded() then
            neotree_zo(state, toggle_all)
        else
            neotree_zc(state, toggle_all)
        end
    end

    --- Recursively close an open folder or recursively open a closed folder.
    local function neotree_zA(state)
        neotree_za(state, true)
    end

    --- Set depthlevel, analagous to foldlevel, for the neo-tree file tree.
    local function set_depthlevel(state, depthlevel)
        if depthlevel < MIN_DEPTH then
            depthlevel = MIN_DEPTH
        end

        local stack = state.tree:get_nodes()
        while next(stack) ~= nil do
            local node = table.remove(stack)

            if node.type == "directory" then
                local should_be_open = depthlevel == nil or node:get_depth() < depthlevel
                if should_be_open and not node:is_expanded() then
                    open_dir(state, node)
                elseif not should_be_open and node:is_expanded() then
                    node:collapse()
                end
            end

            local children = state.tree:get_nodes(node:get_id())
            for _, v in ipairs(children) do
                table.insert(stack, v)
            end
        end

        vim.b.neotree_depthlevel = depthlevel
    end

    --- Refresh the tree UI after a change of depthlevel.
    -- @bool stay Keep the current node revealed and selected
    local function redraw_after_depthlevel_change(state, stay)
        local node = state.tree:get_node()

        if stay then
            require("neo-tree.ui.renderer").expand_to_node(state.tree, node)
        else
            -- Find the closest parent that is still visible.
            local parent = state.tree:get_node(node:get_parent_id())
            while not parent:is_expanded() and parent:get_depth() > 1 do
                node = parent
                parent = state.tree:get_node(node:get_parent_id())
            end
        end

        renderer.redraw(state)
        renderer.focus_node(state, node:get_id())
    end

    --- Update all open/closed folders by depthlevel, then reveal current node.
    local function neotree_zx(state)
        set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
        redraw_after_depthlevel_change(state, true)
    end

    --- Update all open/closed folders by depthlevel.
    local function neotree_zX(state)
        set_depthlevel(state, vim.b.neotree_depthlevel or MIN_DEPTH)
        redraw_after_depthlevel_change(state, false)
    end

    -- Collapse more folders: decrease depthlevel by 1 or count.
    local function neotree_zm(state)
        local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
        set_depthlevel(state, depthlevel - vim.v.count1)
        redraw_after_depthlevel_change(state, false)
    end

    -- Collapse all folders. Set depthlevel to MIN_DEPTH.
    local function neotree_zM(state)
        set_depthlevel(state, MIN_DEPTH)
        redraw_after_depthlevel_change(state, false)
    end

    -- Expand more folders: increase depthlevel by 1 or count.
    local function neotree_zr(state)
        local depthlevel = vim.b.neotree_depthlevel or MIN_DEPTH
        set_depthlevel(state, depthlevel + vim.v.count1)
        redraw_after_depthlevel_change(state, false)
    end

    -- Expand all folders. Set depthlevel to the deepest node level.
    local function neotree_zR(state)
        local top_level_nodes = state.tree:get_nodes()

        local max_depth = 1
        for _, node in ipairs(top_level_nodes) do
            max_depth = math.max(max_depth, recursive_open(state, node))
        end

        vim.b.neotree_depthlevel = max_depth
        redraw_after_depthlevel_change(state, false)
    end

    require("neo-tree").setup({
        git_status_async = false,
        enable_diagnostics = false,
        document_symbols = {
            kinds = {
                File = { icon = "󰈙", hl = "Tag" },
                Namespace = { icon = "󰌗", hl = "Include" },
                Package = { icon = "󰏖", hl = "Label" },
                Class = { icon = "󰌗", hl = "Include" },
                Property = { icon = "󰆧", hl = "@property" },
                Enum = { icon = "󰒻", hl = "@number" },
                Function = { icon = "󰊕", hl = "Function" },
                String = { icon = "󰀬", hl = "String" },
                Number = { icon = "󰎠", hl = "Number" },
                Array = { icon = "󰅪", hl = "Type" },
                Object = { icon = "󰅩", hl = "Type" },
                Key = { icon = "󰌋", hl = "" },
                Struct = { icon = "󰌗", hl = "Type" },
                Operator = { icon = "󰆕", hl = "Operator" },
                TypeParameter = { icon = "󰊄", hl = "Type" },
                StaticMethod = { icon = '󰠄 ', hl = 'Function' },
            }
        },
        close_if_last_window = true,
        use_popups_for_input = false,
        filesystem = {
            scan_mode = "deep",
            async_directory_scan = "never",
            hijack_netrw_behavior = "disabled",
            filtered_items = {
                --These filters are applied to both browsing and searching
                hide_dotfiles = false,
                hide_gitignored = true,
                never_show = {
                    ".git",
                },
            },
            window = {
                mappings = {
                    ["<C-x>"] = "clear_filter",
                    ["<bs>"] = "noop",
                    ["."] = "noop",
                    ["<space>"] = "noop",
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
                ["zo"] = neotree_zo,
                ["zO"] = neotree_zO,
                ["zc"] = neotree_zc,
                ["zC"] = neotree_zC,
                ["za"] = neotree_za,
                ["zA"] = neotree_zA,
                ["zx"] = neotree_zx,
                ["zX"] = neotree_zX,
                ["zm"] = neotree_zm,
                ["zM"] = neotree_zM,
                ["zr"] = neotree_zr,
                ["zR"] = neotree_zR,
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
