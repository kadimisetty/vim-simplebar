" ============================================================================
" File:         simplebar.vim
" Description:  A simple non-attention-seeking status line.
" Maintainer:   Sri Kadimisetty <http://sri.io>
" License:      GNU LESSER GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
" Version:      0.3.6
" ============================================================================


if exists("g:loaded_simplebar_plugin") || &compatible || v:version < 703
    finish
endif
let g:loaded_simplebar_plugin = 1


" Show the status bar
set laststatus=2
"let g:last_mode=""


" Color groups 
" (Prefereably linked to an existing highlight group)
hi default link User1 LineNr
hi default link User2 Comment
hi default link User3 Statement
"Modes
hi User5 ctermfg=LightGreen ctermbg=NONE cterm=bold
"Unfocussed windows
hi default link User7 Visual



" Custom highlight color group that is called when modes change
function! ModeChanged(mode)
    if     a:mode ==# "n"  | hi User5 ctermfg=LightGreen    ctermbg=NONE cterm=bold
    elseif a:mode ==# "i"  | hi User5 ctermfg=Magenta       ctermbg=NONE cterm=bold
    elseif a:mode ==# "r"  | hi User5 ctermfg=DarkRed       ctermbg=NONE cterm=bold
    " @TODO: Visual Mode does not get triggered, need to find a way around it.
    " elseif a:mode ==# "v" || a:mode ==# "V" || a:mode ==# "^V"
    "                          hi User5 ctermfg=Blue          ctermbg=NONE cterm=bold
    else                   | hi User5 ctermfg=fg            ctermbg=NONE
    endif
endfunction


" Return modes as shorter symbols
function! PrettyCurrentMode()
    let l:currentnode = mode()
    if l:currentnode ==# 'n'      | return "ⓝ"
    elseif l:currentnode ==# 'v'  | return "ⓥ"
    elseif l:currentnode ==# 'V'  | return "Ⓥ"
    elseif l:currentnode ==# '' | return "^ⓥ"
    elseif l:currentnode ==# 'i'  | return "ⓘ"
    elseif l:currentnode ==# 'R'  | return "ⓡ"
    else                          | return l:currentnode
    endif
endfunction


"Return file encoding used and whether DOS-BOMs exist in file
function! FileEncoding()
    if &fenc !~ "^$\|utf-8" || &bomb
        return (&fenc!=#''?&fenc:'e̶n̶c̶') . (&bomb ? "-bom" : "" )
    else
        return ""
    endif
endfunction


" @TODO - Make buffer-number-style customisable
" Return buffer number made prettier
function! PrettyBufferNumber(current_buffer_number)
    let l:small_numbers = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
    let l:result = ""
    let l:current_buffer_number_str = string(a:current_buffer_number)

    for i in range(0, len(l:current_buffer_number_str) - 1)
      let l:result .= l:small_numbers[str2nr(l:current_buffer_number_str[i])]
    endfor

    return l:result
endfunction


" Get current git branch from Fugitive
function! FugitiveStatus(marker)
    if exists("g:loaded_fugitive") && g:loaded_fugitive == 1
        return '  ' . substitute(fugitive#statusline(), '\c\v\[?GIT\(([a-z0-9\-_\./:]+)\)\]?', a:marker .' \1', 'g')
    else
        return ''
    endif
endfunction

"To be applied to windows in focus
function! SetStatusLine()
    let &l:statusline=""
    " Switch color to the User1 highlight group
    let &l:statusline.="%1*"
    " @TODO: 
    "       Use slot in statusline.gutter (spaced equal to gutter-width + foldcolumn-width)
    "       to either show total-lines or buf-number

    " File name
    let &l:statusline.=" %20f"
    " Buffer Modified?
    let &l:statusline.="\ %{&modified==0?'':'+'} "

    " @TODO - Set Read-only flag and show with 🚫
    " Switch color to the User2 highlight group
    let &l:statusline.="%2*"

    " Current git branch
    let &l:statusline.="%{FugitiveStatus('ψ')}  "

    " Filetype
    let &l:statusline.="%{strlen(&ft)?&ft:'t̶y̶p̶e̶'}."
    " File Encoding
    let &l:statusline.="%{FileEncoding()}."
    " File Format
    let &l:statusline.="%{strlen(&ff)?&ff:'f̶o̶r̶m̶a̶t̶'}"
    " Flags
    let &l:statusline.=" %h%r%w "

    " Show buffer number
    let &l:statusline.="%{PrettyBufferNumber(bufnr('%'))}  "

    " Right Align From Here
    let &l:statusline.="%= "

    " Location as- total-number-of-lines and current-line-pos-as-percentage
    let &l:statusline.="↕%L·%p"
    " Show location wit a fancy unicode symbol.
    let &l:statusline.="📍 "
    " Column & Line Positon
    let &l:statusline.="%(%c·%l%)"

    " Switch color to the User3 highlight group
    let &l:statusline.="%3*"
    " Current Mode
    let &l:statusline.="%5*%2{PrettyCurrentMode()}  "

    augroup NoticeModeChanges
        au!
        au InsertEnter * call ModeChanged(v:insertmode)
        au InsertChange * call ModeChanged(v:insertmode)
        au InsertLeave * call ModeChanged(mode())
    augroup END
endfunction


"To be applied to windows that have lost focus
function! SetUnfocussedStatusLine()
    let &l:statusline=""
    " Switch color to the User1 highlight group
    let &l:statusline.="%7*"

    " File name
    let &l:statusline.=" %20f"
    " Buffer Modified?
    let &l:statusline.="\ %{&modified==0?'':'+'} "
    " Show buffer number
    let &l:statusline.="%{PrettyBufferNumber(bufnr('%'))}  "
endfunction


"Set the status line
if has('statusline')
    call SetStatusLine()

    augroup FocusAndUnfocussedStatusLineChanges
        au!
        au WinLeave * call SetUnfocussedStatusLine()
        au WinEnter * call SetStatusLine()
    augroup END
endif
