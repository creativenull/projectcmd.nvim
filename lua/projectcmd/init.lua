local utils = require 'projectcmd.utils'
local M = {}

function is_filetype(filepath, filetype)
  local pat = filetype .. '$'
  return string.match(filepath, pat) ~= nil
end

-- Checks if the global variable is properly defined
-- @param key string
-- @return boolean
local function has_key(key)
  if key ~= '' then
    return true
  end

  return false
end

-- Checks if the file exists and match the key
-- @param opts table
-- @return boolean
local function is_key_match(opts)
  if vim.fn.filereadable(opts.filepath) == 0 then
    return false
  end

  local fp = io.open(opts.filepath)
  local first_line = io.input(fp):read()
  fp.close()

  if not first_line then
    return false
  end

  local filekey = string.sub(first_line, 3)

  return filekey == opts.key
end

-- Source the file according to the type
-- @return void
function M.enable()
  local opts = vim.g.projectcmd_options
  local is_vim = is_filetype(opts.filepath, 'vim')
  local is_lua = is_filetype(opts.filepath, 'lua')

  if is_vim then
    vim.cmd('source ' .. opts.filepath)
  elseif is_lua then
    vim.cmd('luafile ' .. opts.filepath)
  end
end

-- Loads the settings.vim into runtime
-- @param opts table
-- @return void
function M.setup(opts)
  opts = utils.validate_opts(opts)

  if has_key(opts.key) then
    if is_key_match(opts) then
      vim.g.projectcmd_options = opts
    end
  else
    utils.print_err('Key is required!')
  end
end

return M
