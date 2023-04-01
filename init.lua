local M = {}

M.xdeps = require("xdeps")

tools = M.xdeps.tools
check_tools = M.xdeps.check_tools()

vim.keymap.set("n", "<leader><leader>cz", function() M.xdeps.check_tools() end)

return M
