local M = {}

M.get_allowlist = function()
  return vim.g['projectcmd#list_filepath'] .. '/allowlist'
end

return M
