local map = vim.keymap.set

local setup = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    local treeutils = require("local/neotree/treeutils")
    local api = require "nvim-tree.api"

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
    end

    require("nvim-tree").setup({
        on_attach = my_on_attach,
        sort = {
            sorter = "case_sensitive",
        },
        view = {
            width = 30,
        },
        renderer = {
            group_empty = false,
        },
        filters = {
            dotfiles = false,
        },
    })

    map('n', '<leader>et', api.tree.open, { desc = "NvimTree Focus", noremap = true })
end

return { setup = setup }
