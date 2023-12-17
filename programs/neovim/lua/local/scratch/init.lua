local map = vim.keymap.set

local setup = function()
    require('scratch').setup({
        scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
        window_cmd = "edit",              -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
        filetypes = { "go", "py", "sc" }, -- you can simply put filetype here
        filetype_details = {              -- or, you can have more control here
            go = {
                requireDir = true,        -- true if each scratch file requires a new directory
                filename = "main.go",     -- the filename of the scratch file in the new directory
                content = { "package main", "", "func main() {", "  ", "}" },
                cursor = {
                    location = { 4, 2 },
                    insert_mode = true,
                },
            },
            ["gp.md"] = {
                cursor = {
                    location = { 8, 3 },
                    insert_mode = true,
                },
                content = {
                    "# topic: ?",
                    "",
                    "- file: placeholder",
                    "- role: You are a general AI assistant.",
                    "",
                    "Write your queries after 🗨:. Run :GpChatRespond to generate response.",
                    "",
                    "---",
                    "",
                    "🗨: ",
                    "",
                },
            },

        },
        localKeys = {
            -- TODO: setup sniprun only for snippets
        }
    })
    map("n", "<BS>f", function()
        require("scratch").scratchOpen()
    end)
    map("n", "<BS>n", function()
        local scratch = require("scratch.scratch_file")
        scratch.scratch()
    end)
end

return { setup = setup }
