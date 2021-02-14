if exists('g:loaded_projectcmd') || &cp
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

if exists('g:projectcmd_options["key"]') == 0
    finish
endif

" For auto source the file
if exists('g:projectcmd_options["autoload"]') == 1 && g:projectcmd_options.autoload == 1
    lua require'projectcmd'.enable()
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_projectcmd = 1
