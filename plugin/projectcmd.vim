if exists('g:loaded_projectcmd') || &cp
  finish
endif

let s:allowlist_filepath = luaeval("require'projectcmd.config'.get_allowlist()")
let s:ignorelist_filepath = luaeval("require'projectcmd.config'.get_ignorelist()")

command! PCmdEnable lua require 'projectcmd'.enable()
command! PCmdLocalConfig lua require 'projectcmd'.open_config()
command! PCmdOpenAllowlist execute ':edit ' . s:allowlist_filepath
command! PCmdOpenIgnorelist execute ':edit ' . s:ignorelist_filepath

let g:loaded_projectcmd = 1
