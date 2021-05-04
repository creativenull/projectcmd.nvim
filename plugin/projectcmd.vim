if exists('g:loaded_projectcmd') || &cp
  finish
endif

let s:allowlist_filepath = luaeval("require'projectcmd.config'.get_allowlist()")
let s:blocklist_filepath = luaeval("require'projectcmd.config'.get_blocklist()")

command! ProjectCmdEnable lua require'projectcmd'.enable()
command! ProjectCmdOpenAllowlist execute ':edit ' . s:allowlist_filepath
command! ProjectCmdOpenBlocklist execute ':edit ' . s:blocklist_filepath

let g:loaded_projectcmd = 1
