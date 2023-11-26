local map = vim.keymap.set

local setup = function(binaries)
    local sniprun = require('sniprun')
    sniprun.setup({
        display = {
            "Classic",
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

    map("n", "<BS>r", function()
        sniprun.run('w')
    end)

    require('scratch').setup({
        scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
        window_cmd = "edit",              -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
        filetypes = { "go", "py", "sc" }, -- you can simply put filetype here
        filetype_details = {              -- or, you can have more control here
            go = {
                requireDir = true,        -- true if each scratch file requires a new directory
                filename = "main",        -- the filename of the scratch file in the new directory
                content = { "package main", "", "func main() {", "  ", "}" },
                cursor = {
                    location = { 4, 2 },
                    insert_mode = true,
                },
            },
            ["gp.md"] = {
                cursor = {
                    location = { 12, 2 },
                    insert_mode = true,
                },
                content = {
                    "# topic: ?",
                    "",
                    '- model: {"top_p":1,"temperature":0.7,"model":"gpt-3.5-turbo-16k"}',
                    "- file: placeholder",
                    "- role: You are a general AI assistant.",
                    "",
                    "Write your queries after 🗨:. Run :GpChatRespond to generate response.",
                    "",
                    "---",
                    "",
                    "🗨:",
                    "",
                },
            },
        },
    })
end

return { setup = setup }
