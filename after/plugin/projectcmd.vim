lua <<EOF
local prompt_show = vim.g['projectcmd#prompt_show']
local loaded = vim.g['projectcmd#loaded_init']

if prompt_show then
  require 'projectcmd'.prompt_enable()
end

if loaded and not prompt_show then
  require 'projectcmd'.no_change_enable()
end
EOF
