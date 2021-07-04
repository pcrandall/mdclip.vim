if exists('g:mdclip_loaded')
   finish
endif

let g:mdclip_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

function! Mdclip()
    if !exists("g:os")
        if has("win64") || has("win32") || has("win16")
            let g:os = "Windows"
        else
            let g:os = substitute(system('uname'), '\n', '', '')
        endif
    endif

    if g:os == "Darwin" || g:os == "Linux"
        if s:wsl()
           :silent exec "!mdclip.exe"
        else
           :silent exec "!mdclip"
        endif
    elseif g:os == "Windows"
       :silent exec "!mdclip.exe"
    endif

    let g:mdclip_tmpname = s:getName()

    call setreg("0", g:mdclip_tmpname)

    if empty(g:mdclip_tmpname)
        execute ":norm p0Vzfo"
        execute ":norm <C-[>"
    else
        let clipboard = getreg("+")
        if clipboard =~ "No image in clipboard"
            execute ":norm p0"
        else
            execute ":norm p0llvi[\"0p0Vzfo"
            execute ":norm <C-[>"
        endif
    endif

endfunction

function! s:wsl()
    let lines = readfile("/proc/version")
    if (lines[0] =~ "icrosoft")
     return 1
    endif
    return 0
endfunction

function! s:getName()
    call inputsave()
    let name = input('Image name: ')
    call inputrestore()
    return name
endfunction

command! -nargs=* Mdclip call Mdclip()

let &cpo = s:save_cpo
unlet s:save_cpo
