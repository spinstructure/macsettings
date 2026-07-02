" ------------------------------------------------------------
" Basic Vim setup
" ------------------------------------------------------------

set nocompatible
filetype off

let maplocalleader = ","


" ------------------------------------------------------------
" Vundle plugin setup
" ------------------------------------------------------------

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'lervag/vimtex'

call vundle#end()


" ------------------------------------------------------------
" Filetype, indentation, and syntax
" ------------------------------------------------------------

filetype plugin indent on
syntax enable


" ------------------------------------------------------------
" TeX / VimTeX configuration
" ------------------------------------------------------------

let g:tex_flavor='latex'

let g:vimtex_compiler_method='latexrun'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

set conceallevel=1
let g:tex_conceal='abdmg'


" ------------------------------------------------------------
" Terminal cursor colors
" ------------------------------------------------------------

if &term =~ "xterm\\|rxvt"
  let &t_SI = "\<Esc>]12;orange\x7"
  let &t_EI = "\<Esc>]12;red\x7"

  silent !echo -ne "\033]12;red\007"
  autocmd VimLeave * silent !echo -ne "\033]112\007"
endif
