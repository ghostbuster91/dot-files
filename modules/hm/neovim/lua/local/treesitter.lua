local api = vim.api

-- ---------------------------------------------------------------------------
-- Incremental selection
--
-- The `main` branch of nvim-treesitter dropped the `incremental_selection`
-- module, so we reimplement it on top of the core `vim.treesitter` API by
-- walking the syntax tree via `node:parent()`. Selection history is kept per
-- window so decrement can step back through the ancestors that increment
-- visited.
-- ---------------------------------------------------------------------------

local history = {} -- [winid] = { node, node, ... }, outermost last

local function range_equal(a, b)
    local a1, a2, a3, a4 = a:range()
    local b1, b2, b3, b4 = b:range()
    return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

local function visual_select(node)
    local srow, scol, erow, ecol = node:range()
    -- treesitter ranges are end-exclusive; convert to an inclusive (row, col)
    if ecol > 0 then
        ecol = ecol - 1
    else
        -- node ends at column 0 of `erow`, i.e. at the end of the line above
        erow = erow - 1
        ecol = math.max(vim.fn.col({ erow + 1, "$" }) - 2, 0)
    end

    -- leave any active visual selection so `v` starts a fresh charwise one
    if api.nvim_get_mode().mode:find("[vV\22]") then
        api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    end

    api.nvim_win_set_cursor(0, { srow + 1, scol })
    vim.cmd("normal! v")
    api.nvim_win_set_cursor(0, { erow + 1, ecol })
end

local function init_selection()
    local node = vim.treesitter.get_node()
    if not node then
        return
    end
    history[api.nvim_get_current_win()] = { node }
    visual_select(node)
end

local function node_incremental()
    local win = api.nvim_get_current_win()
    local nodes = history[win]
    if not nodes or #nodes == 0 then
        return init_selection()
    end

    local current = nodes[#nodes]
    local parent = current:parent()
    -- skip ancestors that cover the exact same range as the current node
    while parent and range_equal(parent, current) do
        parent = parent:parent()
    end

    if parent then
        table.insert(nodes, parent)
        visual_select(parent)
    else
        visual_select(current)
    end
end

local function node_decremental()
    local win = api.nvim_get_current_win()
    local nodes = history[win]
    if not nodes or #nodes == 0 then
        return
    end
    if #nodes > 1 then
        table.remove(nodes)
    end
    visual_select(nodes[#nodes])
end

local setup = function(_next_integrations)
    -- The `main` branch of nvim-treesitter (nixpkgs 26.05) dropped the old
    -- `nvim-treesitter.configs` module together with the `highlight`,
    -- `incremental_selection`, `playground` and `query_linter` sub-modules.
    --   * highlighting is now started per-buffer via `vim.treesitter.start()`
    --   * incremental selection is reimplemented above
    --   * playground is replaced by the built-in `:InspectTree`
    --   * query linting is replaced by the built-in `:EditQuery`
    -- Parsers are provided by nix (see neovim/default.nix), so we just enable
    -- highlighting + treesitter indentation for any buffer whose language has
    -- a parser available; `vim.treesitter.start` errors when it doesn't, which
    -- the pcall swallows.
    require("nvim-treesitter").setup({})

    api.nvim_create_autocmd("FileType", {
        group = api.nvim_create_augroup("local_treesitter", { clear = true }),
        callback = function(args)
            if not pcall(vim.treesitter.start, args.buf) then
                return
            end
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            local opts = { buffer = args.buf }
            vim.keymap.set("n", "<CR>", init_selection,
                vim.tbl_extend("force", opts, { desc = "Treesitter: init selection" }))
            vim.keymap.set("x", "<CR>", node_incremental,
                vim.tbl_extend("force", opts, { desc = "Treesitter: increment selection" }))
            vim.keymap.set("x", "<BS>", node_decremental,
                vim.tbl_extend("force", opts, { desc = "Treesitter: decrement selection" }))
        end,
    })
end

return { setup = setup }
