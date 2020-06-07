if has("autocmd")
  augroup templates
    autocmd BufNewFile *.zsh 0r ~/.vim/templates/skeleton.zsh
  augroup END
endif

" set header title for journal & enter writing mode

function! JournalMode()
    execute 'normal gg'
    let filename = '##' . ' ' . expand('%:r')
    call setline(1, filename)
    execute 'normal o'
endfunction

augroup journal
    autocmd!

" populate journal template
autocmd VimEnter */journal/**   0r ~/.vim/templates/journal.skeleton

" set header for the particular journal
autocmd VimEnter */journal/**   :call JournalMode()

" https://stackoverflow.com/questions/12094708/include-a-directory-recursively-for-vim-autocompletion
autocmd VimEnter */journal/**   set complete=k~/documents/journal/**/*


" this function from https://stackoverflow.com/questions/5006950/setting-netrw-like-nerdtree
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

function! ToggleSpell()
  if !exists("g:showingSpell")
    let g:showingSpell=0
  endif

  if g:showingSpell==0
    execute "hi SpellBad cterm=underline ctermbg=red"
    let g:showingSpell=1
  else
    execute "hi clear SpellBad"
    let g:showingSpell=0
  endif
endfunction
