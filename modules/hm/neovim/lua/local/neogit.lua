local map = vim.keymap.set

local setup = function()
    local neogit = require("neogit")
    neogit.setup({
        disable_commit_confirmation = true,
        integrations = {
            diffview = true,
            telescope = true,
        },
        mappings = {
            status = {
                ["<ESC>"] = "Close",
            },
        },
    })
    map("n", "<leader>ne", function()
        neogit.open()
    end, { desc = "neogit" })
end

return { setup = setup }
