local config = require 'projectcmd.config'
local M = {}

M.add = function(value)
  local file = io.open(config.ALLOWLIST_FILEPATH, 'a+')
  file:write(value .. "\n")
  file:close()
end

M.update = function(filepath, new_hash)
  local contents = {}
  for content in string.gmatch(io.input(config.ALLOWLIST_FILEPATH):read('a'), [[([^]+)]]) do
    table.insert(contents, content)
  end

  for k,v in pairs(contents) do
    local inner_contents = {}
    for content in string.gmatch(v, [[([^ ]+)]]) do table.insert(inner_contents, content) end
    local current_fp = inner_contents[1]
    if current_fp == filepath then
      contents[k] = filepath .. ' ' .. new_hash
    end
  end

  print(vim.inspect(contents))

  -- file:close()
  -- file = io.open(config.ALLOWLIST_FILEPATH, 'w')
  -- local string_contents = ''
  -- for k,v in pairs(contents) do
  --   string_contents = string_contents .. v .. "\n"
  -- end
  -- 
  -- file:write(string_contents)
  -- file:close()
end

M.remove = function(checksum)
end

M.add_allowlist = function(hash)
  local curr_dir = vim.fn.getcwd()
  local init_file = curr_dir .. '/.vim/init.lua'
  M.add(curr_dir .. ' ' .. hash)
  dofile(init_file)
end

M.update_allowlist = function(hash)
  local curr_dir = vim.fn.getcwd()
  M.update(curr_dir, hash)
  dofile(init_file)
end

return M
