" Simple vim plugin to load project specific vimrc/init.vim
" Maintainer: Arnold Chand <creativenull@outlook.com>
" License: MIT

if exists('g:loaded_projectcmd') || &cp
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! ProjectCmd lua require'projectcmd'.setup()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_projectcmd = 1
