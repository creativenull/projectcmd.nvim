local M = {}

M.get_allowlist = function()
  if vim.fn.exists('g:projectcmd#list_filepath') == 0 then
    return vim.fn.expand('~/.cache/nvim-nightly/projectcmd') .. '/allowlist'
  end

  return vim.g['projectcmd#list_filepath'] .. '/allowlist'
end

M.get_ignorelist = function()
  if vim.fn.exists('g:projectcmd#list_filepath') == 0 then
    return vim.fn.expand('~/.cache/nvim-nightly/projectcmd') .. '/ignorelist'
  end

  return vim.g['projectcmd#list_filepath'] .. '/ignorelist'
end

return M
