local api = vim.api
local map = vim.keymap.set
local lsp = vim.lsp
local diag = vim.diagnostic

local setup = function(telescope, telescope_builtin, navic, next_integrations, tsserver_path, typescript_path,
                       metals_binary_path)
    -- lsp
    local lspconfig = require("lspconfig")

    -- global variable to control if lsp should format file on save
    Auto_format = true

    require("lsp-inlayhints").setup()
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local lsp_group = api.nvim_create_augroup("lsp", { clear = true })
    local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
        require("lsp-inlayhints").on_attach(client, bufnr)
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
        mapB("n", "<leader>ch", require('lsp-inlayhints').toggle, "lsp: toggle inlayhints")

        mapB("n", "K", lsp.buf.hover, "lsp hover")
        mapB("n", "<Leader>gr", function()
            telescope_builtin.lsp_references({ layout_strategy = "vertical" })
        end, "lsp references")
        mapB("n", "<leader>sh", lsp.buf.signature_help, "lsp signature")

        local nndiag = next_integrations.diagnostic()
        mapB("n", "[d", nndiag.goto_prev({ wrap = false, severity = { min = diag.severity.WARN } }),
            "previous diagnostic")
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
            typescript_path
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

        mapB("n", "<leader>dT", function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, "dap: toggle breakpoint condition")

        mapB("n", "<leader>dsv", function()
            require("dap").step_over()
        end, "dap: step over")

        mapB("n", "<leader>dsi", function()
            require("dap").step_into()
        end, "dap: step into")

        mapB("n", "<leader>dso", function()
            require("dap").step_out()
        end, "dap: step out")

        mapB("n", "<leader>dl", function()
            require("dap").run_last()
        end, "dap: run last")

        mapB("n", "<leader>du", function()
            require("dapui").toggle()
        end, "dap: ui toggle")

        mapB("n", "<leader>db", function()
            telescope.extensions.dap.list_breakpoints()
        end, "dap: list breakpoints")

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

    -- metals end
end

return { setup = setup }
