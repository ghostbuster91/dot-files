-- globals
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set
local lsp = vim.lsp
local global_opt = vim.opt_global

global_opt.clipboard = "unnamed"
global_opt.timeoutlen = 200

-- lsp
local lspconfig = require("lspconfig")
local nullLs = require("null-ls")

nullLs.setup({
    sources = {
        nullLs.builtins.formatting.shfmt,
        nullLs.builtins.diagnostics.eslint,
        nullLs.builtins.code_actions.eslint,
        nullLs.builtins.formatting.prettier,
    },
})

local actions = require("telescope.actions")
local telescope = require("telescope")
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
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

local telescope_builtin = require('telescope.builtin')
map("n", "<Leader>/", telescope_builtin.commands, { noremap = true, desc = "show commands" })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function mapB(mode, l, r, desc)
        local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
        map(mode, l, r, opts)
    end

    -- Mappings.

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    mapB("n", "<leader>rn", lsp.buf.rename, "lsp rename")
    mapB("n", "<leader>gD", lsp.buf.declaration, "lsp goto declaration")
    mapB("n", "<leader>gd", telescope_builtin.lsp_definitions, "lsp goto definition")
    mapB("n", "<leader>gi", telescope_builtin.lsp_implementations, "lsp goto implementation")
    mapB("n", "<leader>f", lsp.buf.format, "lsp format")
    mapB("n", "<leader>gs", telescope_builtin.lsp_document_symbols, "lsp document symbols")
    mapB(
        "n",
        "<Leader>gws",
        telescope_builtin.lsp_dynamic_workspace_symbols,
        "lsp workspace symbols"
    )
    mapB("n", "<leader>ca", lsp.buf.code_action, "lsp code action")

    mapB("n", "K", lsp.buf.hover, "lsp hover")
    mapB("n", "<Leader>gr", telescope_builtin.lsp_references, "lsp references")
    mapB("n", "<leader>sh", lsp.buf.signature_help, "lsp signature")

    mapB("n", "[d", function() vim.diagnostic.goto_prev({ wrap = false }) end, "previous diagnostic")
    mapB("n", "]d", function() vim.diagnostic.goto_next({ wrap = false }) end, "next diagnostic")

    if client.server_capabilities.documentFormattingProvider then
        cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
            ]])
    end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "bashls", "vimls", "rnix", "yamlls", "sumneko_lua" }
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
metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities
metals_config.on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    map("v", "K", metals.type_of_range)
    map("n", "<leader>cc", function()
        telescope.extensions.coursier.complete()
    end, { desc = "coursier complete" })
    map("n", "<leader>mc", function()
        telescope.extensions.metals.commands()
    end, { desc = "metals commands" })
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

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end, { expr = true })

        map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end, { expr = true })

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

require("nvim-autopairs").setup()

require("nvim-treesitter.configs").setup({
    ensure_installed = {}, -- Revert to full list once https://github.com/NixOS/nixpkgs/issues/189838 will be resolved
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
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
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
})

local gps = require("nvim-gps")
gps.setup()

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
        lualine_c = { "filename", { gps.get_location, cond = gps.is_available } },
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
        { name = "buffer", priority = 9 },
        { name = 'tmux', priority = 8 },
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

require("symbols-outline").setup()

require("noice").setup()
require("telescope").load_extension("noice")

require("fidget").setup({
    debug = {
        logging = true
    }
})

require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

require('eyeliner').setup {
    highlight_on_key = true
}

require('neoscroll').setup()

require("diffview").setup()

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
    default_mappings = true;
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
