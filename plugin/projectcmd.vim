if exists('g:loaded_projectcmd') || &cp
  finish
endif

let s:allowlist_filepath = luaeval("require'projectcmd.config'.get_allowlist()")
let s:blocklist_filepath = luaeval("require'projectcmd.config'.get_blocklist()")

command! ProjectCMDEnable lua require'projectcmd'.enable()
command! ProjectCMDOpenAllowlist execute ':edit ' . s:allowlist_filepath
command! ProjectCMDOpenBlocklist execute ':edit ' . s:blocklist_filepath

let g:loaded_projectcmd = 1
