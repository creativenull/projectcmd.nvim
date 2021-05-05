if exists('g:loaded_projectcmd') || &cp
  finish
endif

let s:allowlist_filepath = luaeval("require'projectcmd.config'.get_allowlist()")

command! ProjectCmdEnable lua require'projectcmd'.enable()
command! ProjectCmdOpenAllowlist execute ':edit ' . s:allowlist_filepath

let g:loaded_projectcmd = 1
