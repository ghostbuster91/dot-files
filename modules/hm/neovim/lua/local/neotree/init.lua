local map = vim.keymap.set

local setup = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local treeutils = require("local/neotree/treeutils")
    local api = require "nvim-tree.api"
    local explorer_node = require "nvim-tree.explorer.node"
    local git = require "nvim-tree.git"
    local explorer = require "nvim-tree.explorer.explore"
    local lib = require "nvim-tree.lib"
    local actions = require "nvim-tree.actions"

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
        map('n', '?', api.tree.toggle_help, opts('NvimTree help'))

        map('n', '<leader>tf', treeutils.launch_find_files, opts('Launch Find Files'))
        map('n', '<leader>ti', treeutils.launch_live_grep, opts('Launch Live Grep'))
        -- map('n', 'ze', api.tree.expand_all, opts("Expand all"))
        local function stop_expansion(_, _)
            return false, stop_expansion
        end
        local function expand_until_non_single(count, node)
            local cwd = node.link_to or node.absolute_path
            local handle = vim.loop.fs_scandir(cwd)
            if not handle then
                return false, stop_expansion
            end
            local status = git.load_project_status(cwd)
            explorer.explore(node, status)
            local child_folder_only = explorer_node.has_one_child_folder(node) and node.nodes[1]
            if count > 1 and not child_folder_only then
                return true, stop_expansion
            elseif child_folder_only then
                return true, expand_until_non_single
            else
                return false, stop_expansion
            end
        end

        local function wrap_node(fn)
            return function(node, ...)
                node = node or lib.get_node_at_cursor()
                if node then
                    fn(node, ...)
                end
            end
        end
        local function edit(mode, node)
            local path = node.absolute_path
            if node.link_to and not node.nodes then
                path = node.link_to
            end
            actions.node.open_file.fn(mode, path)
        end

        local f = function(node)
            if node.open then
                lib.expand_or_collapse(node, nil)
            else
                if node.nodes then
                    api.tree.expand_all(node, expand_until_non_single)
                else
                    edit("edit", node)
                end
            end
        end
        map('n', '<CR>', wrap_node(f), opts("Expand until not single or collapse"))
        map('n', 'Z', api.tree.expand_all, opts("Expand until not single"))
        map('n', 'e', toggle_width_adaptive, opts("Toggle adaptive width"))
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
            }
        },
        renderer = {
            group_empty = false,
            icons = {
                git_placement = "after",
            },
            root_folder_label = ":~:s?$?/"
        },
        filters = {
            dotfiles = false,
            custom = { "^.git$" },
        },
    })
    require("lsp-file-operations").setup()

    map('n', '<leader>et', function()
        api.tree.open({ find_file = true })
    end, { desc = "NvimTree Focus", noremap = true })

    -- from https://github.com/nvim-tree/nvim-tree.lua/issues/1368
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree_*",
        callback = function()
            local layout = vim.api.nvim_call_function("winlayout", {})
            if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
                vim.cmd("confirm quit")
            end
        end
    })

    -- based on https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/1490#discussioncomment-9632938
    vim.api.nvim_create_autocmd({ "BufLeave" }, {
        pattern = { "*NeogitStatus*" },
        group = vim.api.nvim_create_augroup("git_refresh_nvim-tree", { clear = true }),
        callback = function()
            vim.schedule(function()
                api.git.reload()
            end)
        end,
    })
end

return { setup = setup }
