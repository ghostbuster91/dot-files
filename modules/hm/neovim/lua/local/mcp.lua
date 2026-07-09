local M = {}

-- git spawns short-lived nvim instances to edit commit/merge/rebase/tag
-- messages. Those load the full config too, so without a guard each one would
-- call nvim-mcp's serverstart() and register a second socket in the same git
-- root (nvim-mcp.<git-root>.<pid>.sock). get_targets would then return several
-- sockets distinguishable only by PID. Skip setup for those transient editors
-- so exactly one long-lived session registers per repo.
local function is_transient_git_editor()
    for _, arg in ipairs(vim.fn.argv()) do
        if arg:match("COMMIT_EDITMSG$")
            or arg:match("MERGE_MSG$")
            or arg:match("git%-rebase%-todo$")
            or arg:match("TAG_EDITMSG$")
        then
            return true
        end
    end
    return false
end

M.setup = function()
    if is_transient_git_editor() then
        return
    end
    -- Opens the RPC socket (serverstart) that the nvim-mcp binary connects to.
    require("nvim-mcp").setup({})
end

return M
