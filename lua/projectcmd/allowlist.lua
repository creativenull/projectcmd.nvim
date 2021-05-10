local config = require 'projectcmd.config'
local ALLOWLIST_FILEPATH = config.get_allowlist()
local M = {}

-- Add the item to the allowlist
local function _add(value)
  local fp = io.open(ALLOWLIST_FILEPATH, 'a+')
  fp:write(value)
  fp:close()
end

-- Update the item in the allowlist
local function _set(key, value)
  local fpcontents = io.input(ALLOWLIST_FILEPATH):read('a')
  local contents = {}
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end

  for k,v in pairs(contents) do
    local keyvalues = {}
    for content in string.gmatch(v, [[([^ ]+)]]) do table.insert(keyvalues, content) end
    if keyvalues[1] == key then
      contents[k] = value
    end
  end

  local string_contents = table.concat(contents, "\n")

  local fp = io.open(ALLOWLIST_FILEPATH, 'w')
  fp:write(string_contents)
  fp:close()
end

local function _exists(key)
  local fpcontents = io.input(ALLOWLIST_FILEPATH):read('a')

  local contents = {}
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end

  for k,v in pairs(contents) do
    local keyvalues = {}
    for content in string.gmatch(v, [[([^ ]+)]]) do table.insert(keyvalues, content) end
    if keyvalues[1] == key then
      return true
    end
  end

  return false
end

-- Remove the item from the allowlist
local function _remove(key)
end

M.add = function(hash)
  local currdir = vim.fn.getcwd()
  if _exists(currdir) then return end
  local value = string.format('%s %s\n', currdir, hash)
  _add(value)
end

M.update = function(hash)
  local currdir = vim.fn.getcwd()
  local value = string.format('%s %s\n', currdir, hash)
  _set(currdir, value)
end

M.remove = function()
  local currdir = vim.fn.cwd()
  _remove(currdir)
end

return M
