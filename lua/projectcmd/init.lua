local config = require 'projectcmd.config'
local M = {}

local function set_defaults()
  vim.g['projectcmd#loaded_init'] = false
  vim.g['projectcmd#prompt_show'] = false
  vim.g['projectcmd#prompt_msg'] = ''
  vim.g['projectcmd#prompt_code'] = ''
  vim.g['projectcmd#prompt_args'] = ''
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
  -- Create the allowlist file, if it does not exist
  if vim.fn.filereadable(config.ALLOWLIST_FILEPATH) == 0 then
    create_file(config.ALLOWLIST_FILEPATH)
  end
end

local function create_blocklist()
  -- Create the blocklist file, if it does not exist
  if vim.fn.filereadable(config.BLOCKLIST_FILEPATH) == 0 then
    create_file(config.BLOCKLIST_FILEPATH)
  end
end

local function init()
  set_defaults()
  create_allowlist()
  create_blocklist()
end

M.setup = function()
  init()

  local current_dir = vim.fn.getcwd()
  local init_file = current_dir .. '/.vim/init.lua'

  -- Validate file
  if vim.fn.filereadable(init_file) == 0 then
    vim.api.nvim_err_writeln('NOT FOUND')
    return
  end

  -- Get the hash of the file
  local hashed_init = get_hash(init_file)

  -- Check if hash matches allowlist, or changed
  local allowed_found = false
  local changed_checksum = false
  for line in io.lines(config.ALLOWLIST_FILEPATH) do
    local current_line_contents = {}
    for content in string.gmatch(line, [[([^ ]+)]]) do table.insert(current_line_contents, content) end
    local allowed_filepath = current_line_contents[1]
    local allowed_checksum = current_line_contents[2]

    if allowed_filepath == current_dir then
      if allowed_checksum == hashed_init then
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
    for line in io.lines(config.BLOCKLIST_FILEPATH) do
      if current_dir == line then
        blocked_found = true
        break
      end
    end
  end

  if not blocked_found and not allowed_found then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg'] = '[PROJECTCMD] New project config file found, add to allowlist? (y/n/C) '
    vim.g['projectcmd#prompt_code'] = 'NEW'
    vim.g['projectcmd#prompt_args'] = hashed_init
  end

  if changed_checksum then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg'] = '[PROJECTCMD] Config file changed, run? (y/N) '
    vim.g['projectcmd#prompt_code'] = 'CHANGE'
    vim.g['projectcmd#prompt_args'] = hashed_init
  end

  vim.g['projectcmd#loaded_init'] = true
end

return M
