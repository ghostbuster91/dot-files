local map = vim.keymap.set

local setup = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    local treeutils = require("local/neotree/treeutils")
    local api = require("nvim-tree.api")

    local VIEW_WIDTH_FIXED = 30
    local VIEW_WIDTH_ADAPTIVE = -1
    local view_width_max = VIEW_WIDTH_ADAPTIVE -- fixed to start
    -- get current view width
    local function get_view_width_max()
        return view_width_max
    end
    -- toggle the width and redraw
    local function toggle_width_adaptive()
        if view_width_max == VIEW_WIDTH_ADAPTIVE then
            view_width_max = VIEW_WIDTH_FIXED
        else
            view_width_max = VIEW_WIDTH_ADAPTIVE
        end

        require("nvim-tree.api").tree.reload()
    end
    local telescope_actions = require("telescope.actions")
    local function find_directory_and_focus()
        local action_state = require("telescope.actions.state")

        local function open_nvim_tree(prompt_bufnr, _)
            telescope_actions.select_default:replace(function()
                telescope_actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                api.tree.open()
                api.tree.find_file(selection.cwd .. "/" .. selection.value)
            end)
            return true
        end

        require("telescope.builtin").find_files({
            find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
            attach_mappings = open_nvim_tree,
        })
    end

    vim.keymap.set("n", "<leader>id", find_directory_and_focus, { desc = "telescope focus directory" })

    local function my_on_attach(bufnr)
        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        map("n", "?", api.tree.toggle_help, opts("NvimTree help"))

        map("n", "<leader>tf", treeutils.launch_find_files, opts("Launch Find Files"))
        map("n", "<leader>ti", treeutils.launch_live_grep, opts("Launch Live Grep"))
        -- map('n', 'ze', api.tree.expand_all, opts("Expand all"))

        local function has_one_child_folder(node)
            return #node.nodes == 1 and node.nodes[1].nodes and vim.loop.fs_access(node.nodes[1].absolute_path, "R")
                or false
        end

        local function descend_until_non_single(_, node)
            if node.nodes == nil or not node.parent.open then
                return false
            end
            return has_one_child_folder(node.parent)
        end

        -- <CR>: open a file, collapse an open directory, or expand a closed
        -- directory through single-child folder chains using the upstream
        -- expand_until feature (nvim-tree/nvim-tree.lua#3166).
        local function edit_or_expand_until()
            local node = api.tree.get_node_under_cursor()
            if node and node.nodes ~= nil and not node.open then
                api.node.expand(node, { expand_until = descend_until_non_single })
            else
                api.node.open.edit()
            end
        end
        map("n", "<CR>", edit_or_expand_until, opts("Open / expand until non-single"))

        map("n", "Z", function()
            api.tree.expand_all(nil, nil)
        end, opts("Expand all"))
        map("n", "e", toggle_width_adaptive, opts("Toggle adaptive width"))
    end

    require("nvim-tree").setup({
        on_attach = my_on_attach,
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = {
                min = 30,
                max = get_view_width_max,
            },
        },
        renderer = {
            group_empty = false,
            icons = {
                git_placement = "after",
            },
            root_folder_label = ":~:s?$?/",
        },
        filters = {
            dotfiles = false,
            custom = { "^.git$" },
        },
    })
    require("lsp-file-operations").setup()

    map("n", "<leader>et", function()
        api.tree.open({ find_file = true })
    end, { desc = "NvimTree Focus", noremap = true })

    -- from https://github.com/nvim-tree/nvim-tree.lua/issues/1368
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree_*",
        callback = function()
            local layout = vim.api.nvim_call_function("winlayout", {})
            if
                layout[1] == "leaf"
                and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
                and layout[3] == nil
            then
                vim.cmd("confirm quit")
            end
        end,
    })

    -- based on https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/1490#discussioncomment-9632938
    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        pattern = { "*NeogitStatus*" },
        group = vim.api.nvim_create_augroup("git_refresh_nvim-tree", { clear = true }),
        callback = function()
            vim.schedule(function()
                -- Use tree.reload() (goes through reload_explorer) instead of
                -- git.reload() (reload_git): the latter reads git.config.git.enable
                -- which nvim-tree never populates, so it errors when the tree is
                -- open. reload_explorer refreshes git status via a safe path.
                api.tree.reload()
            end)
        end,
    })
end

return { setup = setup }
