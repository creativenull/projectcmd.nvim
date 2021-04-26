local config = require 'projectcmd.config'
local M = {}

-- Add the item to the allowlist
local function _add(value)
  local fp = io.open(config.ALLOWLIST_FILEPATH, 'a+')
  fp:write(value)
  fp:close()
end

-- Update the item in the allowlist
local function _set(key, value)
  local fpcontents = io.input(config.ALLOWLIST_FILEPATH):read('a')
  local contents = {}
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end

  for k,v in pairs(contents) do
    local keyvalues = {}
    for content in string.gmatch(v, [[([^ ]+)]]) do table.insert(keyvalues, content) end
    if keyvalues[1] == key then
      contents[k] = value
    end
  end

  print(vim.inspect(contents))

  local string_contents = ''
  for k,value in pairs(contents) do
    string_contents = string_contents .. value
  end

  local fp = io.open(config.ALLOWLIST_FILEPATH, 'w')
  fp:write(string_contents)
  fp:close()
end

-- Remove the item from the allowlist
local function _remove(key)
end

M.add = function(hash)
  local currdir = vim.fn.getcwd()
  local value = currdir .. ' ' .. hash .. "\n"
  _add(value)
end

M.update = function(hash)
  local currdir = vim.fn.getcwd()
  local value = currdir .. ' ' .. hash .. "\n"
  _set(currdir, value)
end

M.remove = function()
  local currdir = vim.fn.cwd()
end

return M
