lua <<EOF
local message_enabled = vim.g['projectcmd#message_enabled']
local prompt_show = vim.g['projectcmd#prompt_show']
local loaded = vim.g['projectcmd#loaded_init']
local currdir = vim.fn.getcwd()
local init_filepath = currdir .. vim.g['projectcmd#config_filepath']

if prompt_show then
  local prompt_msg = vim.g['projectcmd#prompt_msg']
  local prompt_hash = vim.g['projectcmd#prompt_args']
  local prompt_code = vim.g['projectcmd#prompt_code']
  vim.fn.inputsave()
  local answer = vim.fn.input(prompt_msg)
  vim.fn.inputrestore()

  if answer == 'y' then
    if prompt_code == 'NEW' then
      require 'projectcmd.allowlist'.add(prompt_hash)
    elseif prompt_code == 'CHANGE' then
      require 'projectcmd.allowlist'.update(prompt_hash)
    end

    dofile(init_filepath)
    print('[PROJECTCMD] Local Config Loaded!')
  end
end

if loaded and not prompt_show then
  dofile(init_filepath)
  print('[PROJECTCMD] Local Config Loaded!')
end
EOF
