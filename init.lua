local M = {}

M.xdeps = require("xdeps")

tools = M.xdeps.tools
check_tools = M.xdeps.check_tools()

vim.keymap.set("n", "<leader><leader>cz", function() print("hello") end)

return M
