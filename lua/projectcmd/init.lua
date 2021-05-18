local utils = require('projectcmd.utils')
local M = {}

local function set_defaults(opts)
  vim.g['projectcmd#loaded_init'] = false
  vim.g['projectcmd#prompt_show'] = false
  vim.g['projectcmd#prompt_msg']  = ''
  vim.g['projectcmd#prompt_code'] = ''
  vim.g['projectcmd#prompt_args'] = ''

  if opts == nil then opts = {} end

  if opts.root_dir == nil then
    vim.g['projectcmd#list_filepath'] = vim.fn.expand('~/.cache/nvim-nightly/projectcmd')
  else
    vim.g['projectcmd#list_filepath'] = opts.root_dir
  end

  if opts.project_config_filepath == nil then
    vim.g['projectcmd#config_filepath'] = '/.vim/init.lua'
  else
    vim.g['projectcmd#config_filepath'] = opts.project_config_filepath
  end

  if opts.enable == nil then
    vim.g['projectcmd#enable'] = true
  else
    vim.g['projectcmd#enable'] = opts.enable
  end

  vim.g['projectcmd#message_load_response'] = '[PROJECTCMD] Local Config Loaded!'
  if opts.show_message == nil then
    vim.g['projectcmd#message_enabled'] = true
  else
    vim.g['projectcmd#message_enabled'] = opts.show_message
  end
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- TODO: Find out a way to hash content w/o platform dependent tools
local function get_hash(filepath)
  local cmd = string.format([[md5sum %s | cut "-d " -f1]], filepath)
  local handle = io.popen(cmd)
  local result = handle:read(32)
  result = trim(result)
  handle:close()
  return result
end

local function createfile(filename)
  local filepath = string.format('%s/%s', vim.g['projectcmd#list_filepath'], filename)
  if vim.fn.filereadable(filepath) == 1 then return end
  local file = io.open(filepath, 'w')
  file:write()
  file:close()
end

local function exists(filepath)
  return vim.fn.filereadable(filepath) == 1
end

local function init(opts)
  -- set default options on initialize
  set_defaults(opts)

  -- create files if they don't exists
  createfile('allowlist')
  createfile('ignorelist')
end

M.setup = function(opts)
  init(opts)
  local config = require 'projectcmd.config'
  local ignorelist = require 'projectcmd.ignorelist'
  local allowlist = config.get_allowlist()
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

  -- Check if in ignorelist
  if ignorelist.has(currdir) then
    return
  end

  -- Show prompt for new and changed file
  if not allowed_found then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg']  = string.format(
      '[PROJECTCMD] New project config file found at: "%s", add to allowlist? (y/n/C) ',
      vim.g['projectcmd#config_filepath']
    )
    vim.g['projectcmd#prompt_code'] = 'NEW'
    vim.g['projectcmd#prompt_args'] = hashed_contents
  end

  if changed_checksum then
    vim.g['projectcmd#prompt_show'] = true
    vim.g['projectcmd#prompt_msg']  = string.format(
      '[PROJECTCMD] Config file changed at "%s", run? (y/N) ',
      vim.g['projectcmd#config_filepath']
    )
    vim.g['projectcmd#prompt_code'] = 'CHANGE'
    vim.g['projectcmd#prompt_args'] = hashed_contents
  end

  vim.g['projectcmd#loaded_init'] = true
end

-- Manually soruce the file and if in the ignorelist, then remove it
M.enable = function()
  local ignorelist = require 'projectcmd.ignorelist'
  local allowlist = require 'projectcmd.allowlist'
  local message = vim.g['projectcmd#message_load_response']
  local message_enabled = vim.g['projectcmd#message_enabled']
  local currdir = vim.fn.getcwd()
  local init_filepath = currdir .. vim.g['projectcmd#config_filepath']
  if not exists(init_filepath) then return end

  -- Remove from ignorelist
  if ignorelist.has(currdir) then
    ignorelist.remove(currdir)
  end

  -- Add to allowlist
  local hashed_contents = get_hash(init_filepath)
  allowlist.add(hashed_contents)

  -- Source the file
  utils.source_by_type(init_filepath)
  if message_enabled then print(message) end
end

-- Prompt the user to remember and source the file
-- or source the file again if any changes were made to the file
M.prompt_enable = function()
  local allowlist = require 'projectcmd.allowlist'
  local ignorelist = require 'projectcmd.ignorelist'
  local enable = vim.g['projectcmd#enable']
  local currdir = vim.fn.getcwd()
  local init_filepath = currdir .. vim.g['projectcmd#config_filepath']
  local message = vim.g['projectcmd#message_load_response']
  local message_enabled = vim.g['projectcmd#message_enabled']
  local prompt_msg = vim.g['projectcmd#prompt_msg']
  local prompt_hash = vim.g['projectcmd#prompt_args']
  local prompt_code = vim.g['projectcmd#prompt_code']

  vim.fn.inputsave()
  local answer = vim.fn.input(prompt_msg)
  vim.fn.inputrestore()

  if answer == 'y' then
    -- Source the file
    if prompt_code == 'NEW' then
      allowlist.add(prompt_hash)
    elseif prompt_code == 'CHANGE' then
      allowlist.update(prompt_hash)
    end

    if enable then
      -- dofile(init_filepath)
      utils.source_by_type(init_filepath)
      if message_enabled then
        -- Make sure message is printed in a new line
        print(" \n" .. message)
      end
    end
  elseif answer == 'n' then
    -- Add to ignorelist
    if prompt_code == 'NEW' then
      ignorelist.add(currdir)
    end
  end
end

-- Source the file if in allowlist, where there is no change
-- or a new file to be sourced
M.no_change_enable = function()
  local enable = vim.g['projectcmd#enable']
  local message_enabled = vim.g['projectcmd#message_enabled']
  local currdir = vim.fn.getcwd()
  local message = vim.g['projectcmd#message_load_response']
  local init_filepath = currdir .. vim.g['projectcmd#config_filepath']

  if enable then
    utils.source_by_type(init_filepath)
    if message_enabled then
      print(message)
    end
  end
end

-- Open the local config file if exists
-- else, create it
M.open_config = function()
  local currdir = vim.fn.getcwd()
  local init_filepath = currdir .. vim.g['projectcmd#config_filepath']

  if not exists(init_filepath) then
    return
  end

  vim.cmd('edit ' .. init_filepath)
end

return M
