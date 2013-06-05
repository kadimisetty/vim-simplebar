
function! Tellmode()
    let mycurrentmode = mode()
    if mycurrentmode ==# 'n'
        return "Ⓝ"
    elseif mycurrentmode ==# 'no'
        return 'Ⓝ , op pending'
    elseif mycurrentmode ==# 'v'
        return "ⓥ"
    elseif mycurrentmode ==# 'V'
        return "Ⓥ"
    elseif mycurrentmode ==# 'CTRL-V'
        return "CTRL-Ⓥ"
    elseif mycurrentmode ==# 'i'
        return "Ⓘ"
    elseif mycurrentmode ==# 'R'
        return "Ⓡ"
    elseif mycurrentmode ==# 'Rv'
        return "VIRT - Ⓡ"
    elseif mycurrentmode ==# 'c'
        return "Ⓒ"
    elseif mycurrentmode ==# 'cv'
        return "VIM - EX"
    elseif mycurrentmode ==# 'ce'
        return "NORM - EX"
    elseif mycurrentmode ==# 'r'
        return "hit enter prompt"
    elseif mycurrentmode ==# 'rm'
        return "the more prompt"
    elseif mycurrentmode ==# 'r?'
        return ":confirm query"
    elseif mycurrentmode ==# '!'
        return "shell/ext command running"
    else 
        return mycurrentmode
    endif
endfunction

hi User1 ctermbg=0 ctermfg=10
hi User2 ctermbg=Black ctermfg=Gray
hi User3 ctermbg=NONE ctermfg=10
hi User4 ctermbg=NONE ctermfg=100

set statusline=
set statusline+=%1* 
set statusline+=%3L\ 
set statusline+=%10f 
set statusline+=\ 
set statusline+=%3*  
set statusline+=\ \ \ 
set statusline+=✍\ 
set statusline+=%{strlen(&ft)?&ft:'unknown'}\ 
set statusline+=%{&ff}\ 
set statusline+=\ \ 
set statusline+=%(%l·%L%) 
set statusline+=\📍 
set statusline+=\ %P
set statusline+=%=
set statusline+=%4*  
set statusline+=%{Tellmode()}\ \ 
