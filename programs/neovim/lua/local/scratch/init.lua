local map = vim.keymap.set

local setup = function(binaries)
    local sniprun = require('sniprun')
    sniprun.setup({
        display = {
            "Terminal", -- todo change it to something else as its behavior is buggy? (e.g. try insert mode)
        },
        -- cannot add more interpreters for now because they mostly assume global installations
        -- without any option to configure binaries https://github.com/michaelb/sniprun/issues/263
        interpreter_options = {
            Go_original = {
                compiler = binaries.go
            },
            Python3_original = {
                interpreter = binaries.python,
            },
            Generic = {
                ScalaCLI = {                           -- any key name is ok
                    supported_filetypes = { "scala" }, -- mandatory
                    extension = ".sc",                 -- recommended, but not mandatory. Sniprun use this to create temporary files
                    compiler = binaries.scalaCLI,      -- one of those MUST be non-empty
                }
            }
        },
    })

    map("n", "<leader>rs", function()
        sniprun.run('w')
    end, { desc = "sniprun: execute buffer" })
    map("v", "<leader>rs", function()
        sniprun.run('v')
    end, { desc = "sniprun: execute visual selection" })

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
