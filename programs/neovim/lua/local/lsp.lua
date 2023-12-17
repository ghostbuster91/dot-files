local api = vim.api
local map = vim.keymap.set
local lsp = vim.lsp
local diag = vim.diagnostic

local setup = function(telescope, telescope_builtin, navic, next_integrations, binaries)
    local M = {
        on_attach_dap_subscribers = {}
    }
    M.virtual_text = {
        enabled = false,
        enable = function()
            M.virtual_text.enabled = true
            diag.config({ virtual_text = true })
            vim.notify("virtual text enabled", vim.log.levels.INFO, { title = "LSP" })
        end,
        disable = function()
            M.virtual_text.enabled = false
            diag.config({ virtual_text = false })
            vim.notify("virtual text disabled", vim.log.levels.INFO, { title = "LSP" })
        end,
        toggle = function()
            if M.virtual_text.enabled then
                M.virtual_text.disable()
            else
                M.virtual_text.enable()
            end
        end,
    }
    diag.config({ virtual_text = M.virtual_text.enabled })

    M.auto_format = {
        enabled = true,
        enable = function()
            M.auto_format.enabled = true
            vim.notify("auto format enabled", vim.log.levels.INFO, { title = "LSP" })
        end,
        disable = function()
            M.auto_format.enabled = false
            vim.notify("auto format disabled", vim.log.levels.INFO, { title = "LSP" })
        end,
        toggle = function()
            if M.auto_format.enabled then
                M.auto_format.disable()
            else
                M.auto_format.enable()
            end
        end
    }
    -- setup neodev in a way that it loads all plugins when editing dot-files
    local username = vim.fn.expand('$USER')
    local dotfiles_dir = "/home/" .. username .. "/workspace/dot-files"
    require("neodev").setup({
        override = function(root_dir, library)
            if root_dir:find(dotfiles_dir, 1, true) then
                library.enabled = true
                library.plugins = true
            end
        end,
    })
    local lspconfig = require("lspconfig")

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

        local vertical_layout = { layout_strategy = "vertical", fname_width = 80 }
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        mapB("n", "<leader>rn", lsp.buf.rename, "[lsp] rename")
        mapB("n", "<leader>gD", function()
            lsp.buf.declaration(vertical_layout)
        end, "[lsp] goto declaration")
        mapB("n", "<leader>nd", function()
            telescope_builtin.lsp_definitions(vertical_layout)
        end, "[lsp] goto definition")
        mapB("n", "<leader>ni", function()
            telescope_builtin.lsp_implementations(vertical_layout)
        end, "[lsp] goto implementation")
        mapB("n", "<leader>f", lsp.buf.format, "[lsp] format")
        mapB("n", "<leader>nt", function()
            telescope_builtin.lsp_document_symbols(vim.tbl_extend("force",
                { symbols = { "class", "method", "function" } },
                vertical_layout))
        end, "[lsp] document symbols")
        map(
            "n",
            "<Leader>ns",
            function()
                telescope_builtin.lsp_dynamic_workspace_symbols(vertical_layout)
            end,
            { desc = "[lsp] workspace symbols" }
        )
        mapB({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions, "[lsp] code actions")
        mapB("n", "<leader>cl", lsp.codelens.run, "[lsp] code lenses")

        -- mapB("n", "K", lsp.buf.hover, "lsp hover")
        mapB("n", "<Leader>nr", function()
            telescope_builtin.lsp_references(vertical_layout)
        end, "[lsp] references")
        mapB("n", "<leader>sh", lsp.buf.signature_help, "[lsp] signature")

        if client.server_capabilities.documentFormattingProvider then
            local augroup = api.nvim_create_augroup('LspFormatting', { clear = true })
            api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                desc = 'format with lsp on save',
                callback = function()
                    if M.auto_format.enabled then
                        lsp.buf.format()
                    end
                end
            })
        end
        -- Enable inlay hints if the client supports it.
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
        end
    end

    local null_ls = require("null-ls")
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

    M.spell_check = {
        enabled = false,
        toggle = function()
            if M.spell_check.enabled then
                M.spell_check.disable()
            else
                M.spell_check.enable()
            end
        end,
        enable = function()
            null_ls.enable({ name = "cspell" })
            M.spell_check.enabled = true
            vim.notify("Spell check enabled", vim.log.levels.INFO, { title = "null_ls" })
        end,
        disable = function()
            null_ls.disable({ name = "cspell" })
            M.spell_check.enabled = false
            vim.notify("Spell check disabled", vim.log.levels.INFO, { title = "null_ls" })
        end
    }
    if not M.spell_check.enabled then
        null_ls.disable({ name = "cspell" })
    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local servers = { "bashls", "vimls", "yamlls", "rust_analyzer", "gopls" }
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
            binaries.tsserver_path,
            "--stdio",
            "--tsserver-path",
            binaries.typescript_path
        }
    })
    local library = vim.api.nvim_get_runtime_file('*.lua', true)
    require("lspconfig").lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { binaries.lua_language_server },
        settings = {
            Lua = {
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    checkThirdParty = false,
                    library = library
                },
            }
        }
    })
    require('lspconfig').nil_ls.setup({
        capabilities = capabilities,
        settings = {
            ['nil'] = {
                formatting = {
                    command = { binaries.nix_fmt },
                },
            },
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
        mapB("n", "<leader>mt", require("metals.tvp").toggle_tree_view, "metals: toggle tree view")

        mapB("n", "<leader>mr", require("metals.tvp").reveal_in_tree, "metals: reveal in tree")

        mapB("n", "<leader>msi", function()
            require("metals").toggle_setting("showImplicitArguments")
        end, "metals: show implicit args")
        mapB("n", "<leader>mss", function()
            require("metals").toggle_setting("enableSemanticHighlighting")
        end, "metals: toggle enableSemanticHighlighting")

        -- TODO: investigate why it doesnt work
        -- map("n", "<leader>cc", telescope.extensions.coursier.complete, { desc = "coursier complete" })
        map("n", "<leader>mc", telescope.extensions.metals.commands, { desc = "metals commands" })
        mapB("n", "<leader>mk", metals.hover_worksheet, "metals: hover worksheet")

        local dap_interface = {
            continue = dap.continue,
            toggle_repl = dap.repl.toggle,
            hover = require("dap.ui.widgets").hover,
            step_out = dap.step_out,
            step_into = dap.step_into,
            step_over = dap.step_over,
            run_last = dap.run_last,
            run_to_cursor = dap.run_to_cursor,
            attach = function()
                --TODO fixe me; use somehow https://github.com/scalameta/nvim-metals/blob/32a37ce2f2cdafd0f1c5a44bcf748dae6867c982/lua/metals/setup.lua#L109-L168
                --todo should ask for buildTarget and port?
                dap.run({ type = 'scala', request = 'attach', host = '127.0.0.1', port = 5005, buildTarget = "root" })
            end,
            toggle_ui = require("dapui").toggle,
            toggle_breakpoint = dap.toggle_breakpoint,
            set_breakpoint = function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            terminate = function()
                dap.disconnect({ terminateDebuggee = false })
            end,
        }
        for _, subscriber in ipairs(M.on_attach_dap_subscribers) do
            subscriber.on_attach(client, bufnr, dap_interface)
        end

        mapB("n", "<leader>dl", dap_interface.run_last, "dap: Run last")
        mapB("n", "<leader>dd", dap_interface.toggle_breakpoint, "dap: toggle breakpoint")

        dap.listeners.after["event_terminated"]["nvim-metals"] = function(_, _)
            vim.notify("Tests have finished!", vim.log.levels.INFO, { title = "Metals" })
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
        metalsBinaryPath = binaries.metals_binary_path,
        showImplicitArguments = true,
        superMethodLensesEnabled = false,
        excludedPackages = {
            "akka.actor.typed.javadsl",
            "com.github.swagger.akka.javadsl"
        },
        enableSemanticHighlighting = false
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
    telescope.load_extension('dap')

    local function metals_status_handler(err, status, ctx)
        if status.statusType == "metals" then
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
        elseif status.statusType == "bsp" and status.text then
            local scaped_status = status.text:gsub("^%s*(.-)%s*$", "%1")
            vim.api.nvim_set_var("metals_bsp_status", scaped_status)
        else
            vim.notify("Unknown status from metals: " .. vim.inspect(status))
        end
    end

    metals_config.init_options.statusBarProvider = 'on'
    metals_config.handlers = { ['metals/status'] = metals_status_handler }

    -- metals end

    lspconfig.smithy_ls.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
        end,
        cmd = { binaries.smithy_ls_path, '0' },
        root_dir = lspconfig.util.root_pattern("smithy-build.json")
    }


    local misc_group = api.nvim_create_augroup("misc", { clear = true })
    api.nvim_create_autocmd('FileType', {
        pattern = { "log" },
        callback = function()
            require('baleia').setup({}).once(0)
        end,
        group = misc_group
    })
    return M
end

return { setup = setup }
