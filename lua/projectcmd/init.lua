local M = {}

local function set_defaults(opts)
  vim.g['projectcmd#loaded_init'] = false
  vim.g['projectcmd#prompt_show'] = false
  vim.g['projectcmd#prompt_msg']  = ''
  vim.g['projectcmd#prompt_code'] = ''
  vim.g['projectcmd#prompt_args'] = ''

  if opts == nil or opts.list_filepath == nil then
    vim.g['projectcmd#list_filepath'] = vim.fn.expand('~/.cache/nvim-nightly/projectcmd')
  else
    vim.g['projectcmd#list_filepath'] = opts.list_filepath
  end

  if opts == nil or opts.config_filepath == nil then
    vim.g['projectcmd#config_filepath'] = '/.vim/init.lua'
  else
    vim.g['projectcmd#config_filepath'] = opts.config_filepath
  end

  if opts == nil or opts.message_enabled == nil then
    vim.g['projectcmd#message_enabled'] = true
  else
    vim.g['projectcmd#message_enabled'] = opts.message_enabled
  end
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function get_hash(filepath)
  local cmd = string.format([[md5sum %s | cut "-d " -f1]], filepath)
  local handle = io.popen(cmd)
  local result = handle:read(32)
  result = trim(result)
  handle:close()

  return result
end

local function create_file(filepath)
  local file = io.open(filepath, 'w')
  file:write('')
  file:close()
end

local function create_allowlist()
  local allowlist = require 'projectcmd.config'.get_allowlist()
  -- Create the allowlist file, if it does not exist
  if vim.fn.filereadable(allowlist) == 0 then
    create_file(allowlist)
  end
end

local function create_blocklist()
  local blocklist = require 'projectcmd.config'.get_blocklist()
  -- Create the blocklist file, if it does not exist
  if vim.fn.filereadable(blocklist) == 0 then
    create_file(blocklist)
  end
end

local function init(opts)
  -- set default options on initialize
  set_defaults(opts)

  -- create files if they don't exists
  create_allowlist()
  create_blocklist()
end

M.setup = function(opts)
  init(opts)
  local config = require 'projectcmd.config'
  local allowlist = config.get_allowlist()
  local blocklist = config.get_blocklist()
  local currdir = vim.fn.getcwd()
  local init_filepath = currdir .. vim.g['projectcmd#config_filepath']

  -- Ignore execution if not found
  if vim.fn.filereadable(init_filepath) == 0 then
    return
  end

  -- Get the hash of the file
  local hashed_contents = get_hash(init_filepath)

  -- Check if hash matches allowlist, or changed
  local allowed_found = false
  local changed_checksum = false
  for line in io.lines(allowlist) do
    local current_line_contents = {}
    for content in string.gmatch(line, [[([^ ]+)]]) do table.insert(current_line_contents, content) end
    local allowed_filepath = current_line_contents[1]
    local allowed_checksum = current_line_contents[2]

    if allowed_filepath == currdir then
      if allowed_checksum == hashed_contents then
        allowed_found = true
        break
      else
        allowed_found = true
        changed_checksum = true
        break
      end
    end
  end

  -- Check if the filepath matches in blocklist
  local blocked_found = false
  if not allowed_found then
    for line in io.lines(blocklist) do
      if currdir == line then
        blocked_found = true
        break
      end
    end
  end

  if not blocked_found and not allowed_found then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg']  = '[PROJECTCMD] New project config file found, add to allowlist? (y/n/C) '
    vim.g['projectcmd#prompt_code'] = 'NEW'
    vim.g['projectcmd#prompt_args'] = hashed_contents
  end

  if changed_checksum then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg']  = '[PROJECTCMD] Config file changed, run? (y/N) '
    vim.g['projectcmd#prompt_code'] = 'CHANGE'
    vim.g['projectcmd#prompt_args'] = hashed_contents
  end

  vim.g['projectcmd#loaded_init'] = true
end

return M
