-- globals
local global_opt = vim.opt_global
global_opt.clipboard = "unnamed"

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

-- Saving files as root with w!! {
vim.api.nvim_set_keymap("c", "w!!", "%!sudo tee > /dev/null %", { noremap = true })
-- }

-- <CTRL> + a and <CTRL> + e move to the beginning and the end of the line
vim.api.nvim_set_keymap("c", "<C-a>", "<HOME>", { noremap = true })
vim.api.nvim_set_keymap("c", "<C-e>", "<END>", { noremap = true })
-- }

vim.api.nvim_set_keymap("n", "<Leader>/", "<cmd>lua require('telescope.builtin').commands()<cr>",
	{ noremap = true })

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<Leader>gtD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "<Leader>gtd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
	buf_set_keymap("n", "<Leader>gds", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", opts)
	buf_set_keymap(
		"n",
		"<Leader>gws",
		"<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>",
		opts
	)

	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "<Leader>glr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", opts)

	if client.server_capabilities.documentFormattingProvider then
		vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
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

require("gitsigns").setup({
	on_attach = function(bufnr)
		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end

		local opts = { noremap = true, silent = true }
		-- Navigation
		map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		-- Actions
		map("n", "<Leader>hs", ":Gitsigns stage_hunk<CR>", opts)
		map("v", "<Leader>hs", ":Gitsigns stage_hunk<CR>", opts)
		map("n", "<Leader>hr", ":Gitsigns reset_hunk<CR>", opts)
		map("v", "<Leader>hr", ":Gitsigns reset_hunk<CR>", opts)
		-- TODO why this doesnt work and freezes vim!?
		map("n", "<leader>hS", "<cmd>Gitsigns stage_buffer<CR>")
		map("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>")
		map("n", "<leader>hR", "<cmd>Gitsigns reset_buffer<CR>")
		map("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", opts)
		map("n", "<leader>hb", '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
		map("n", "<leader>tb", "<cmd>Gitsigns toggle_current_line_blame<CR>")
		map("n", "<leader>hd", "<cmd>Gitsigns diffthis<CR>")
		map("n", "<leader>hD", '<cmd>lua require"gitsigns".diffthis("~")<CR>')
		map("n", "<leader>td", "<cmd>Gitsigns toggle_deleted<CR>")

		-- Text object
		map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
		map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>", opts)
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

	-- tree-sitter-nix doesn't work with indent enabled.
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
	}
})

local actions = require("telescope.actions")

require("telescope").setup({
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

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

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
			mode = "symbol", -- show only symbol annotations
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
vim.keymap.set("n", '<leader>"', require("telescope").extensions.neoclip.star)

require("indent_blankline").setup()

require("nvim-tree").setup()

require("symbols-outline").setup()

require('dressing').setup()

require("noice").setup()
require("telescope").load_extension("noice")

require('dressing').setup({
	input = {
		-- Change default highlight groups (see :help winhl)
		winhighlight = "FloatBorder:DiagnosticError",
	},
})
require("fidget").setup()
require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
require 'eyeliner'.setup {
	highlight_on_key = true
}
require('neoscroll').setup()

require("diffview").setup()
require('neogit').setup {
	integrations = {
		diffview = true
	}
}
