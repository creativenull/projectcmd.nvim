local M = {}

local function _get(value)
  local ignorelistpath = require 'projectcmd.config'.get_ignorelist()
  local fpcontents = io.input(ignorelistpath):read('a')

  if vim.fn.filereadable(ignorelistpath) == 1 and fpcontents == '' then
    return nil
  end

  local contents = {}
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end
  for k,v in pairs(contents) do
    if v == value then
      return value
    end
  end

  return nil
end

local function _add(value)
  local ignorelistpath = require 'projectcmd.config'.get_ignorelist()
  local fpcontents = io.input(ignorelistpath):read('a')

  -- if files is empty then just add new value to it
  if vim.fn.filereadable(ignorelistpath) == 1 and fpcontents == '' then
    local fp = io.open(ignorelistpath, 'w')
    local contents = string.format('%s\n', value)
    fp:write(contents)
    fp:close()
    return
  end

  local contents = {}

  -- if exists don't do anything
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end
  for k,v in pairs(contents) do
    if v == value then
      return
    end
  end

  -- else add to the list
  table.insert(contents, value)

  -- write to the file
  local string_contents = table.concat(contents, '\n')
  local fp = io.open(ignorelistpath, 'w')
  fp:write(string_contents)
  fp:close()
end

local function _has(value)
  local content = _get(value)
  return content ~= nil
end

local function _remove(value)
  local ignorelistpath = require 'projectcmd.config'.get_ignorelist()
  local fpcontents = io.input(ignorelistpath):read('a')

  -- if files is empty then just add new value to it
  if vim.fn.filereadable(ignorelistpath) == 1 and fpcontents == '' then
    return
  end

  local contents = {}

  -- if exists don't do anything
  for content in string.gmatch(fpcontents, [[([^]+)]]) do table.insert(contents, content) end
  for k,v in pairs(contents) do
    if v == value then
      table.remove(contents, k)
    end
  end

  -- write to the file
  local string_contents = table.concat(contents, '\n')
  local fp = io.open(ignorelistpath, 'w')
  fp:write(string_contents)
  fp:close()
end

M.has = _has
M.add = _add
M.remove = _remove

return M
