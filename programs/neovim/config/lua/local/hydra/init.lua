local setup = function(lsp)
    local hydra = require("hydra")
    require("local/hydra/options").setup(hydra, lsp)
end

return { setup = setup }
