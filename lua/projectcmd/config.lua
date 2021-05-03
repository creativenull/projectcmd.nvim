local M = {}

M.get_allowlist = function()
  return vim.g['projectcmd#list_filepath'] .. '/allowlist'
end

M.get_blocklist = function()
  return vim.g['projectcmd#list_filepath'] .. '/blocklist'
end

return M
