-- This file will be inlined into home-manager initial configuration
-- globals
local api = vim.api
local map = vim.keymap.set
local global_opt = vim.opt_global
local diag = vim.diagnostic

global_opt.clipboard = "unnamed"
global_opt.timeoutlen = 200

local next_integrations = require("nvim-next.integrations")

vim.cmd([[au BufRead,BufNewFile *.smithy setfiletype smithy]])
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


local navic = require("nvim-navic")

local hocon_group = api.nvim_create_augroup("hocon", { clear = true })
api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead' },
    { group = hocon_group, pattern = '*/resources/*.conf', command = 'set ft=hocon' }
)


require("which-key").setup()

require("nvim-autopairs").setup({
    check_ts = true,
})


require("Comment").setup()

require("neoclip").setup()
require("telescope").load_extension("neoclip")
map("n", '<leader>"', require("telescope").extensions.neoclip.star, { desc = "clipboard" })

require("indent_blankline").setup()

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- require("nvim-tree").setup({
--     view = {
--         adaptive_size = true,
--     },
-- })
-- map("n", '<leader>et', function()
--     require("nvim-tree.api").tree.toggle(true, true)
-- end, { desc = "nvim_tree toggle" })
-- map("n", '<leader>ef', function()
--     require("nvim-tree.api").tree.find_file(false, true)
-- end, { desc = "nvim_tree toggle" })


require("fidget").setup({
    debug = {
        logging = true
    }
})

require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

-- local diffview_actions = next_integrations.diffview(require("diffview.actions"))
-- require("diffview").setup({
--     file_history_panel = {
--         keymaps = {
--             { "n", "[x", diffview_actions.prev_conflict, { desc = "In the merge-tool: jump to the previous conflict" } },
--             { "n", "]x", diffview_actions.next_conflict, { desc = "In the merge-tool: jump to the next conflict" } },
--         }
--     }
-- })

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
    default_mappings = false,
}


map("n", "k", function()
    diag.open_float()
end, { desc = "show diagnostic under the cursor" })

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
        vim.notify("No more items", vim.log.levels.INFO, { title = "Quickfix" })
    end
end, function(_)
    local status, err = pcall(vim.cmd, "cnext")
    if not status then
        vim.notify("No more items", vim.log.levels.INFO, { title = "Quickfix" })
    end
end)

map("n", "]q", next_qf_item, { desc = "nvim-next: next qfix" })
map("n", "[q", prev_qf_item, { desc = "nvim-next: prev qfix" })

local nndiag = next_integrations.diagnostic()
map("n", "[d", nndiag.goto_prev({ wrap = false, severity = { min = diag.severity.WARN } }),
    { desc = "previous diagnostic" })
map("n", "]d", nndiag.goto_next({ wrap = false, severity = { min = diag.severity.WARN } }), { desc = "next diagnostic" })

require("gitlinker").setup()

require("local/trouble").setup()
local telescope = require("local/telescope").setup()
require("local/noice").setup(telescope.core)
local lsp = require("local/lsp").setup(telescope.core, telescope.builtin, navic, next_integrations, tsserver_path,
    typescript_path,
    metals_binary_path, smithy_ls_path)
require("local/gitsigns").setup(next_integrations)
require("local/cmp").setup()
require("local/lualine").setup(navic)
require("local/treesitter").setup(next_integrations)
require("local/neoscroll").setup()
require("local/smart-split").setup()
require("local/dial").setup()
require("local/hydra").setup(lsp)
require("local/neotree").setup()
