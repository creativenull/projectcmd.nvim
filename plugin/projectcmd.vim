if exists('g:loaded_projectcmd') || &cp
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! ProjectCmdEnable lua require 'projectcmd'.enable()

let &cpo = s:save_cpo
unlet s:save_cpo
