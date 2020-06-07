set nocompatible              " be iMproved, required
filetype off                  " required

" visual candy

syntax enable

set relativenumber

" set background=dark
highlight Normal ctermbg=NONE
highlight CursorLineNr ctermfg=blue
highlight SignColumn ctermbg=NONE

"
set cul

" Force order of line endings.
set ffs=unix,dos

" Follow auto indent, use hard tabs, of width 2.
set autoindent smarttab tabstop=2 shiftwidth=2 expandtab

" Don't wrap lines outside of words.
set wrap breakindent linebreak nolist nostartofline

"============================================
" this config from https://github.com/bhalash/vimrc-lite/blob/master/vimrc
" Save file when it loses focus.
set autowrite 

" More frequent saves and bigger undo history.
set updatecount=50 history=2000 undolevels=2000

" Keep a persistent backup file.
set undofile undodir=.undo,~/tmp,/tmp

" Disable swap files.
set noswapfile

" Highlight the current line and set the colour.

"=============================================


" Search & display
set incsearch smartcase hlsearch showmatch

" SPELLING:
" toggle spellcheck highlighting with F5
map <F5> :call ToggleSpell()<CR> 

set spell spelllang=en_gb
iabbrev teh the

" backup to dropbox on each save
:command W !rclone copy % dropbox:tmp


" clear spelling highlights by default
" Force to use underline for spell check results
augroup SpellUnderline
  autocmd!
  autocmd ColorScheme * highlight SpellBad   ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellCap   ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellLocal ctermfg=NONE ctermbg=NONE
  autocmd ColorScheme * highlight SpellRare  ctermfg=NONE ctermbg=NONE
augroup END

" FINDNG FILES:
filetype plugin on

" tab completion on all files
set path+=**
set wildmenu wildmode=list:full
set autochdir

" TAG JUMPING:
command! MakeTags !ctags -R .

" FILE BROWSING:
"
let g:netrw_banner=0            " disable browser
let g:netrw_browse_split=4      " open in prior window
let g:netrw_altv=1              " open splits to the right
let g:netrw_liststyle=3         " tree view
let g:netrw_winsize = 25



" VUNDLE:
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Vundle manages itself
Plugin 'wakatime/vim-wakatime'
call vundle#end()            " required
filetype plugin indent on    " required

" colo industry

source ~/.vim/local_functions.vim


map <silent> <C-E> :call ToggleVExplorer()<CR>
" set noru nornu nonu " remove cruft
   
set rulerformat=%#TabLineSel#\ %{WordCount()}%#Statement#\ %m\ %#VisualNOS#\ %l:%c


 
function WordCount()
  let s:old_status = v:statusmsg
  exe "silent normal g\<c-g>"
  let s:word_count = str2nr(split(v:statusmsg)[11])
  let v:statusmsg = s:old_status
  return s:word_count
endfunction

