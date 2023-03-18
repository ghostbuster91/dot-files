-- globals
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set
local lsp = vim.lsp
local global_opt = vim.opt_global
local diag = vim.diagnostic

global_opt.clipboard = "unnamed"
global_opt.timeoutlen = 200

local next_integrations = require("nvim-next.integrations")
-- lsp
local lspconfig = require("lspconfig")

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
    extensions = {
            ["ui-select"] = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        }
    }
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

-- Saving files as root with w!! {
map("c", "w!!", "%!sudo tee > /dev/null %", { noremap = true })
-- }

-- <CTRL> + a and <CTRL> + e move to the beginning and the end of the line
map("c", "<C-a>", "<HOME>", { noremap = true })
map("c", "<C-e>", "<END>", { noremap = true })
-- }

map("n", "<F11>", ":wall<CR>", { noremap = true, silent = true })
map("n", "<leader>su", function()
    diag.setqflist()
end, { desc = "Diagnostics into qflist" })
map("n", "<leader>se", function()
    diag.setqflist({ severity = "E" })
end, { desc = "Diagnostics[E] into qflist" })

local toggle_qf = function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    vim.cmd "copen"
end
map("n", "<leader>to", toggle_qf, { desc = "qflist toggle" })

local telescope_builtin = require('telescope.builtin')
map("n", "<Leader>/", telescope_builtin.commands, { noremap = true, desc = "show commands" })
map(
    "n",
    "<Leader>gwd",
    function()
        telescope_builtin.diagnostics({ layout_strategy = "vertical" })
    end,
    { desc = "diagnostics" }
)

-- global variable to control if lsp should format file on save
Auto_format = true

local navic = require("nvim-navic")
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
    local function mapB(mode, l, r, desc)
        local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
        map(mode, l, r, opts)
    end

    -- Mappings.

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    mapB("n", "<leader>rn", lsp.buf.rename, "lsp rename")
    mapB("n", "<leader>gD", function()
        lsp.buf.declaration({ layout_strategy = "vertical" })
    end, "lsp goto declaration")
    mapB("n", "<leader>gd", function()
        telescope_builtin.lsp_definitions({ layout_strategy = "vertical" })
    end, "lsp goto definition")
    mapB("n", "<leader>gi", function()
        telescope_builtin.lsp_implementations({ layout_strategy = "vertical" })
    end, "lsp goto implementation")
    mapB("n", "<leader>f", lsp.buf.format, "lsp format")
    mapB("n", "<leader>gs", function()
        telescope_builtin.lsp_document_symbols({ layout_strategy = "vertical" })
    end, "lsp document symbols")
    map(
        "n",
        "<Leader>gws",
        function()
            telescope_builtin.lsp_dynamic_workspace_symbols({ layout_strategy = "vertical" })
        end,
        { desc = "lsp workspace symbols" }
    )
    mapB({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
    mapB("n", "<leader>cl", lsp.codelens.run)

    mapB("n", "K", lsp.buf.hover, "lsp hover")
    mapB("n", "<Leader>gr", function()
        telescope_builtin.lsp_references({ layout_strategy = "vertical" })
    end, "lsp references")
    mapB("n", "<leader>sh", lsp.buf.signature_help, "lsp signature")

    local nndiag = next_integrations.diagnostic()
    mapB("n", "[d", nndiag.goto_prev({ wrap = false, severity = { min = diag.severity.WARN } }), "previous diagnostic")
    mapB("n", "]d", nndiag.goto_next({ wrap = false, severity = { min = diag.severity.WARN } }), "next diagnostic")

    if client.server_capabilities.documentFormattingProvider then
        local augroup = api.nvim_create_augroup('LspFormatting', { clear = true })
        api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            desc = 'format with lsp on save',
            callback = function()
                if Auto_format then
                    lsp.buf.format()
                end
            end
        })
    end
end

local null_ls = require("null-ls")
local spell_check_enabled = false
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.code_actions.eslint,
        null_ls.builtins.diagnostics.cspell.with({
            -- Force the severity to be HINT
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = diag.severity.HINT
            end,
        }),
        null_ls.builtins.code_actions.cspell,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.statix,
    },
    on_attach = function(client, bufnr)
        local function mapB(mode, l, r, desc)
            local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
            map(mode, l, r, opts)
        end

        local nndiag = next_integrations.diagnostic()
        on_attach(client, bufnr)
        mapB("n", "[s", nndiag.goto_prev({ wrap = false, severity = diag.severity.HINT }), "previous misspelled word")
        mapB("n", "]s", nndiag.goto_next({ wrap = false, severity = diag.severity.HINT }), "next misspelled word")
    end,
})
if not spell_check_enabled then
    null_ls.disable({ name = "cspell" })
end
map("n", "<leader>ss", function()
    if spell_check_enabled then
        null_ls.disable({ name = "cspell" })
        spell_check_enabled = false
    else
        null_ls.enable({ name = "cspell" })
        spell_check_enabled = true
    end
end, { desc = "toggle spell check", noremap = true })

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "bashls", "vimls", "rnix", "yamlls", "lua_ls", "rust_analyzer" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- after 150ms of no calls to lsp, send call
        -- compare with throttling that is done by default in compe
        -- flags = {
        --   debounce_text_changes = 150,
        -- }
    })
end

-- metals

local capabilities_no_format = lsp.protocol.make_client_capabilities()
capabilities_no_format.textDocument.formatting = false
capabilities_no_format.textDocument.rangeFormatting = false
capabilities_no_format.textDocument.range_formatting = false

require("lspconfig")["tsserver"].setup({
    on_attach = function(client, buffer)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        on_attach(client, buffer)
    end,
    capabilities = capabilities_no_format,
    cmd = {
        tsserver_path,
        "--stdio",
        "--tsserver-path",
        tyescript_path
    }
})

-- Scala nvim-metals config
local metals = require("metals")
local metals_config = metals.bare_config()
metals_config.tvp = {
    icons = {
        enabled = true,
    },
}
metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities

local dap = require("dap")

dap.configurations.scala = {
    {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
            runType = "runOrTestFile",
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        },
    },
    {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
            runType = "testTarget",
        },
    },
}

metals_config.on_attach = function(client, bufnr)
    local function mapB(mode, l, r, desc)
        local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
        map(mode, l, r, opts)
    end
    on_attach(client, bufnr)
    metals.setup_dap()
    mapB("v", "K", metals.type_of_range, "metals: type of range")

    -- TODO: investigate why it doesnt work
    -- map("n", "<leader>cc", telescope.extensions.coursier.complete, { desc = "coursier complete" })
    map("n", "<leader>mc", telescope.extensions.metals.commands, { desc = "metals commands" })

    mapB("n", "<leader>dc", function()
        require("dap").continue()
    end, "dap: continue")

    mapB("n", "<leader>dr", function()
        require("dap").repl.toggle()
    end, "dap: repl toggle")

    mapB("n", "<leader>dK", function()
        require("dap.ui.widgets").hover()
    end, "dap: ui widget")

    mapB("n", "<leader>dt", function()
        require("dap").toggle_breakpoint()
    end, "dap: toggle breakpoint")

    mapB("n", "<leader>dso", function()
        require("dap").step_over()
    end, "dap: step over")

    mapB("n", "<leader>dsi", function()
        require("dap").step_into()
    end, "dap: step into")

    mapB("n", "<leader>dl", function()
        require("dap").run_last()
    end, "dap: run last")

    dap.listeners.after["event_terminated"]["nvim-metals"] = function(_, _)
        --vim.notify("Tests have finished!")
        dap.repl.open()
    end

    api.nvim_create_autocmd("FileType", {
        pattern = { "dap-repl" },
        callback = function()
            require("dap.ext.autocompl").attach()
        end,
        group = lsp_group,
    })
end

metals_config.settings = {
    metalsBinaryPath = metals_binary_path,
    showImplicitArguments = true,
    excludedPackages = {
        "akka.actor.typed.javadsl",
        "com.github.swagger.akka.javadsl"
    }
}
metals_config.handlers["textDocument/publishDiagnostics"] = lsp.with(
    lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            prefix = '',
        }
    }
)
-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
        metals.initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})

telescope.load_extension("metals")

-- metals end

local hocon_group = api.nvim_create_augroup("hocon", { clear = true })
api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = hocon_group, pattern = '*/resources/*.conf', command = 'set ft=hocon' }
)

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        local nngs = next_integrations.gitsigns(gs)
        -- Navigation
        map('n', ']c', nngs.next_hunk, { expr = true, desc = "next change" })
        map('n', '[c', nngs.prev_hunk, { expr = true, desc = "previous change" })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer, { desc = "git:stage buffer" })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = "git:undo stage hunk" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "git:reset buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "git:preview hunk" })
        map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "git:toggle blame" })
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = "git:current line blame" })
        map('n', '<leader>hd', gs.diffthis, { desc = "git:show diff" })
        map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "git:show diff~" })
        map('n', '<leader>td', gs.toggle_deleted, { desc = "git:toggle deleted" })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
})

require("which-key").setup()

require("nvim-autopairs").setup({
    enable_check_bracket_line = false -- doesn't work well when writing schema
})

next_integrations.treesitter_textobjects()
require("nvim-treesitter.configs").setup({
    ensure_installed = {},
    highlight = {
        enable = true, -- false will disable the whole extension                 -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        disable = {}, -- treesitter interferes with VimTex
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
                    ['@function.outer'] = 'V', -- linewise
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
            include_surrounding_whitespace = true,
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
    }
})

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
            { navic.get_location, cond = navic.is_available },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {},
})

require("Comment").setup()

-- luasnip setup
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
-- nvim-cmp setup
local lspkind = require("lspkind")
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        }),
    },
    mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
            ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
            ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
            ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = "nvim_lsp", priority = 10 },
        { name = "buffer",   priority = 9 },
        { name = 'tmux',     priority = 8 },
        { name = "luasnip" },
        { name = "path" },
    },
})

require("neoclip").setup()
require("telescope").load_extension("neoclip")
map("n", '<leader>"', require("telescope").extensions.neoclip.star, { desc = "clipboard" })

require("indent_blankline").setup()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
local nvim_tree = require("nvim-tree")
nvim_tree.setup({
    view = {
        adaptive_size = true,
    },
})
map("n", '<leader>tt', function()
    nvim_tree.toggle(true, true)
end, { desc = "nvim_tree toggle" })

require("noice").setup({
    lsp = { progress = { enabled = false } },
    notify = {
        -- Noice can be used as `vim.notify` so you can route any notification like other messages
        -- Notification messages have their level and other properties set.
        -- event is always "notify" and kind can be any log level as a string
        -- The default routes will forward notifications to nvim-notify
        -- Benefit of using Noice for this is the routing and consistent history view
        enabled = true,
        view = "mini",
    },
    messages = {
        enabled = true,      -- enables the Noice messages UI
        view = "mini",       -- default view for messages
        view_error = "mini", -- view for errors
        view_warn = "mini",  -- view for warnings
    }
})
require("telescope").load_extension("noice")

require("fidget").setup({
    debug = {
        logging = true
    }
})

require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

local diffview_actions = next_integrations.diffview(require("diffview.actions"))
require("diffview").setup({
    file_history_panel = {
        keymaps = {
            { "n", "[x", diffview_actions.prev_conflict, { desc = "In the merge-tool: jump to the previous conflict" } },
            { "n", "]x", diffview_actions.next_conflict, { desc = "In the merge-tool: jump to the next conflict" } },
        }
    }
})

local neogit = require('neogit')
neogit.setup {
    disable_commit_confirmation = true,
    integrations = {
        diffview = true
    }
}
map("n", '<leader>n', function()
    neogit.open()
end, { desc = "neogit" })

require('goto-preview').setup {
    default_mappings = true,
}

local function metals_status_handler(err, status, ctx)
    local val = {}
    -- trim and remove spinner
    local text = status.text:gsub('[⠇⠋⠙⠸⠴⠦]', ''):gsub("^%s*(.-)%s*$", "%1")
    if status.hide then
        val = { kind = "end" }
    elseif status.show then
        val = { kind = "begin", title = text }
    elseif status.text then
        val = { kind = "report", message = text }
    else
        return
    end
    local msg = { token = "metals", value = val }
    lsp.handlers["$/progress"](err, msg, ctx)
end

metals_config.init_options.statusBarProvider = 'on'
metals_config.handlers = { ['metals/status'] = metals_status_handler }

require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true }
)
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true }
)
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
    { silent = true, noremap = true }
)
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
    { silent = true, noremap = true }
)
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
    { silent = true, noremap = true }
)

require("lsp_lines").setup()
map("", "<Leader>j", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
diag.config({ virtual_lines = { only_current_line = true }, virtual_text = false })

local leap = require("leap")
leap.add_default_mappings()
-- The below settings make Leap's highlighting a bit closer to what you've been
-- used to in Lightspeed.
api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
api.nvim_set_hl(0, 'LeapMatch', {
    fg = 'white', -- for light themes, set to 'black' or similar
    bold = true,
    nocombine = true,
})
leap.opts.highlight_unlabeled_phase_one_targets = true
--
local nvim_next_builtins = require("nvim-next.builtins")
require("nvim-next").setup({
    default_mappings = {
        repeat_style = "directional",
    },
    items = {
        nvim_next_builtins.f,
        nvim_next_builtins.t
    }
})
local next_move = require("nvim-next.move")
local prev_qf_item, next_qf_item = next_move.make_repeatable_pair(function(_)
    local status, err = pcall(vim.cmd, "cprevious")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end, function(_)
    local status, err = pcall(vim.cmd, "cnext")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO)
    end
end)

map("n", "]q", next_qf_item, { desc = "nvim-next: next qfix" })
map("n", "[q", prev_qf_item, { desc = "nvim-next: prev qfix" })

require 'treesitter-context'.setup()
