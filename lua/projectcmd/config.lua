local M = {}

local CONFIG_FILEPATH = vim.fn.expand('~/.cache/nvim-nightly/projectcmd')
M.ALLOWLIST_FILEPATH = CONFIG_FILEPATH .. '/allowlist'
M.BLOCKLIST_FILEPATH = CONFIG_FILEPATH .. '/blocklist'

return M
