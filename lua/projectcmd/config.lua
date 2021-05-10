local M = {}

M.get_allowlist = function()
  return vim.g['projectcmd#list_filepath'] .. '/allowlist'
end

M.get_ignorelist = function()
  return vim.g['projectcmd#list_filepath'] .. '/ignorelist'
end

return M
