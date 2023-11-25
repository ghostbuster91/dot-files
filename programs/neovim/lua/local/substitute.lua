local setup = function()
    local substitute = require("substitute")
    substitute.setup()
    vim.keymap.set("n", "h", substitute.operator, { noremap = true })
    vim.keymap.set("n", "hh", substitute.line, { noremap = true })
    vim.keymap.set("n", "H", substitute.eol, { noremap = true })
    vim.keymap.set("x", "h", substitute.visual, { noremap = true })
    return substitute
end

return {
    setup = setup
}
