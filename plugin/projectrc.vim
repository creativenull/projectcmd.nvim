if exists('g:loaded_projectrc') || &cp
    finish
endif

let g:loaded_projectrc = 1

let s:save_cpo = &cpo
set cpo&vim

command! ProjectRC lua require'projectrc'.setup()

let &cpo = s:save_cpo
unlet s:save_cpo
