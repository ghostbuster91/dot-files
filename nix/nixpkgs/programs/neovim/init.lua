-- globals
local global_opt = vim.opt_global
global_opt.clipboard = "unnamed"

-- lsp
local lspconfig = require("lspconfig")
local nullLs = require("null-ls")

nullLs.setup({
	sources = {
		nullLs.builtins.formatting.stylua,
		nullLs.builtins.formatting.shfmt,
	},
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "<Leader>rnm", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<Leader>gtD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "<Leader>gtd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
	end
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
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

require("gitsigns").setup()

require("which-key").setup()

require("nvim-autopairs").setup()

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"nix",
		"yaml",
		"bash",
		"lua",
		"typescript",
		"javascript"
	},
	highlight = {
		enable = true, -- false will disable the whole extension                 -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
		disable = {}, -- treesitter interferes with VimTex
	},

	-- tree-sitter-nix doesn't work with indent enabled.
	indent = {
		enable = false,
	},
})

local trouble = require("trouble.providers.telescope")
local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<c-t>"] = trouble.open_with_trouble,
				["<esc>"] = actions.close,
			},
			n = { ["<c-t>"] = trouble.open_with_trouble },
		},
	},
})

require("telescope").load_extension("fzf")
