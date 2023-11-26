local setup = function()
    local map = vim.keymap.set
    local flash = require("flash")
    map({ "n", "x", "o" }, 's', function() flash.jump() end, { desc = "Flash", noremap = true })
    map({ "n", "x", "o" }, 'S', function() flash.treesitter() end, { desc = "Flash treesitter" })
    map({ "o" }, 'r', function() flash.remote() end, { desc = "Flash remote" })
    map({ "o" }, 'R', function() flash.treesitter_search() end, { desc = "Treesitter search" })
    map({ "c" }, '<c-s>', function() flash.jump() end, { desc = "Toggle Flash Search" })
    flash.setup({
        labels = "neiotsrah,./luydcxzpfwbjgmvk",
        mode = "search",
        search = {
            -- search/jump in all windows
            multi_window = false,
        }
    })
end

return { setup = setup }
