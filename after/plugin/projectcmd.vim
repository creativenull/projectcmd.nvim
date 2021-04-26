lua <<EOF
local prompt_show = vim.g['projectcmd#prompt_show']
local loaded = vim.g['projectcmd#loaded_init']

if prompt_show == true then
  local prompt_msg = vim.g['projectcmd#prompt_msg']
  local prompt_hash = vim.g['projectcmd#prompt_args']
  local prompt_code = vim.g['projectcmd#prompt_code']
  vim.fn.inputsave()
  local answer = vim.fn.input(prompt_msg)
  vim.fn.inputrestore()

  if answer == 'y' then
    if prompt_code == 'NEW' then
      require 'projectcmd.allowlist'.add_allowlist(prompt_hash)
    elseif prompt_code == 'CHANGE' then
      require 'projectcmd.allowlist'.update_allowlist(prompt_hash)
    end
  elseif answer == 'n' then
  end
end

if loaded then
  dofile(vim.fn.getcwd() .. '/.vim/init.lua')
end
EOF
