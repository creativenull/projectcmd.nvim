local config = require 'projectcmd.config'
local M = {}

-- Get the settings filepath in the current working dir
-- @return string|nil
local function get_filepath()
  local project_vim_settings_dir = vim.fn.getcwd() .. '/.vim/settings.vim'
  local project_lua_settings_dir = vim.fn.getcwd() .. '/.vim/settings.lua'

  if vim.fn.filereadable(project_vim_settings_dir) == 1 then
    return project_vim_settings_dir
  elseif vim.fn.filereadable(project_lua_settings_dir) == 1 then
    return project_lua_settings_dir
  end

  return nil
end

-- Print debug type
-- @param str string
-- @return void
function M.printd(str)
  print(config.PRINTF_PLUGIN .. ' ' .. str)
end

-- Print error
-- @param str string
-- @return void
function M.print_err(str)
  vim.api.nvim_err_writeln(config.PRINTF_PLUGIN .. ' ' .. str)
end

-- Validate user options
-- @param opts table
-- @return table
function M.validate_opts(opts)
  if opts.key == nil then
    opts.key = ''
  end

  opts.filepath = get_filepath()

  if opts.autoload == nil then
    opts.autoload = false
  end

  return opts
end

return M
