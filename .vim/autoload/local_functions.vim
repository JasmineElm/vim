"==========================================================
"   TOGGLE EXPLORER WINDOW 
"==========================================================
"
" see https://stackoverflow.com/a/5636941 
"
function! local_functions#ToggleVExplorer() abort
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

"==========================================================
"   TOGGLE SPELLCHECK HIGHLIGHTING 
"==========================================================
"
function! local_functions#ToggleSpell() abort
  if !exists("g:showingSpell")
    let g:showingSpell=0
  endif

  if g:showingSpell==0
    execute "hi SpellBad    cterm=underline ctermbg=red"
    execute "hi SpellCap    ctermbg=blue"
    execute "hi SpellLocal  ctermbg=green"
    execute "hi SpellRare   ctermbg=blue"

    let g:showingSpell=1
  else
    execute "hi clear SpellBad"
    execute "hi clear Spellcap"
    execute "hi clear SpellLocal"
    execute "hi clear SpellRare"
    let g:showingSpell=0
  endif
endfunction

"==========================================================
"    WORD COUNT
"==========================================================
"
" see https://stackoverflow.com/a/4588161

function! local_functions#WordCount()
  let s:old_status = v:statusmsg
  let position = getpos(".")
  exe ":silent normal g\<c-g>"
  let stat = v:statusmsg
  let s:word_count = 0
  if stat != '--No lines in buffer--'
    if stat =~ "^Selected"
      let s:word_count = str2nr(split(v:statusmsg)[5])
    else
      let s:word_count = str2nr(split(v:statusmsg)[11])
    end
    let v:statusmsg = s:old_status
  end
  call setpos('.', position)
  return s:word_count 
endfunction

" CtrlP function for inserting a markdown link with Ctrl-X
function! local_functions#CtrlPOpenFunc(action, line) abort
   if a:action =~ '^h$'    
      " Get the filename
      let filename = fnameescape(fnamemodify(a:line, ':t'))
	  let filename_wo_timestamp = fnameescape(fnamemodify(a:line, ':t:s/\d+-//'))

      " Close CtrlP
      call ctrlp#exit()
      call ctrlp#mrufiles#add(filename)

      " Insert the markdown link to the file in the current buffer
	  let mdlink = "[ ".filename_wo_timestamp." ]( ".filename." )"
      put=mdlink
  else    
      " Use CtrlP's default file opening function
      call call('ctrlp#acceptfile', [a:action, a:line])
   endif
endfunction

let g:ctrlp_open_func = { 
         \ 'files': 'CtrlPOpenFunc',
         \ 'mru files': 'CtrlPOpenFunc' 
         \ }

function! local_functions#ZoteroCite() abort
  " pick a format based on the filetype (customize at will)
  " see https://retorque.re/zotero-better-bibtex/citing/cayw/, requires zotero to be on...
  let format = &filetype =~ '.*md' ? 'citep' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction
