if exists('g:mdclip_loaded')
   finish
endif

let g:mdclip_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

nmap <silent> <C-V> :call Mdclip()<cr>

command! -nargs=* Mdclip call Mdclip()

function! Mdclip()
  let g:mdclip_tmpname = s:InputName()
  call setreg("0", g:mdclip_tmpname)

  if has("win64") || has("win32") || has("win16")
      :silent exec "!mdclip.exe"
  else
      :silent exec "!mdclip"
  endif

  if empty(g:mdclip_tmpname)
    execute ":norm p0Vzf"
  else
    execute ":norm p0llvi[p0Vzf"
  endif

endfunction

function! s:InputName()
    call inputsave()
    let name = input('Image name: ')
    call inputrestore()
   return name
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
