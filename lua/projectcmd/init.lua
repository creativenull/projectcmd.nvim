local M = {}
local ALLOWLIST_FILEPATH = vim.fn.expand('~/.cache/nvim-nightly/projectcmd/allowlist')
local BLOCKLIST_FILEPATH = vim.fn.expand('~/.cache/nvim-nightly/projectcmd/blocklist')

local function set_defaults()
  vim.g['projectcmd#loaded_init'] = false
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

M.setup = function()
  set_defaults()

  local current_dir = vim.fn.getcwd()
  local init_file = current_dir .. '/.vim/init.lua'

  -- Validate file
  if vim.fn.filereadable(init_file) == 0 then
    vim.api.nvim_err_writeln('NOT FOUND')
    return
  end

  local hash = get_hash(init_file)

  -- Get allowlist contents
  if vim.fn.filereadable(ALLOWLIST_FILEPATH) == 0 then
    vim.api.nvim_err_writeln('ALLOWLIST NOT CREATED')
    return
  end

  local allowed_found = false
  local changed_checksum = false
  for line in io.lines(ALLOWLIST_FILEPATH) do
    local current_line_contents = {}
    for content in string.gmatch(line, [[([^ ]+)]]) do table.insert(current_line_contents, content) end
    local allowed_filepath = current_line_contents[1]
    local allowed_checksum = current_line_contents[2]

    if allowed_filepath == current_dir then
      if allowed_checksum == hash then
        allowed_found = true
        break
      else
        allowed_found = true
        changed_checksum = true
        break
      end
    end
  end

  if changed_checksum then
    vim.fn.inputsave()
    local answer = vim.fn.input('[PROJECTCMD] Config file changed, run? (y/N) ')
    vim.fn.inputrestore()
    print(answer)
  end

  -- If not found check blocklist
  local blocked_found = false
  if not allowed_found then
    for line in io.lines(BLOCKLIST_FILEPATH) do
      if current_dir == line then
        blocked_found = true
        break
      end
    end
  end

  if not blocked_found and not allowed_found then
    vim.fn.inputsave()
    local answer = vim.fn.input('[PROJECTCMD] New config file, add to allowlist? (y/n/C) ')
    vim.fn.inputrestore()
    print(answer)
  end


  -- Execute the file
  vim.g['projectcmd#loaded_init'] = true
end

return M
