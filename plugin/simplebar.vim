" ============================================================================
" File:         simplebar.vim
" Description:  A simple non-attention-seeking Vim status line.
" Maintainer:   Sri Kadimisetty <http://sri.io>
" License:      GNU LESSER GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
" Version:      0.3.5
" ============================================================================


if exists("g:loaded_simplebar_plugin") || &compatible || v:version < 700
    echo "needs to be above or equal to version 7.3"
    finish
endif
let g:loaded_simplebar_plugin = 1

"Dev settings
" nnoremap <leader>sl :call SetStatusLine()<CR>
" nnoremap <leader>st :source %<CR>

"Always show the status bar
set laststatus=2
"let g:last_mode=""


"Colors
hi default link User1 LineNr
hi default link User2 Comment
hi default link User3 Statement
hi User5 ctermfg=LightGreen ctermbg=NONE cterm=bold


" Change the User1 highlight group values based on mode
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


"Use a symbol to indicate few modes
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

"Return file encoding used amd report a DOS bom
function! FileEncoding()
    if &fenc !~ "^$\|utf-8" || &bomb
        return (&fenc!=#''?&fenc:'e̶n̶c̶') . (&bomb ? "-bom" : "" )
    else
        return ""
    endif
endfunction

" @TODO - Allow configurable option for buffer number style
" Return Pretty Buffer Numbers
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

"Set the status line
if has('statusline')
    let &statusline=""
    " Switch color to the LineNr highlight group
    let &statusline.="%1*"
    " let &statusline.="  ⒙" | "🚫
    " @TODO: %L matched with gutter width + fold column width
    " File name
    let &statusline.=" %20f"
    " Modified Buffer?
    let &statusline.="\ %{&modified==0?'':'+'} "

    " @TODO - Set Read-only flag and show with 🚫

    " Switch color to the Comment highlight group
    let &statusline.="%2*"

    " Current git branch
    let &statusline.="%{FugitiveStatus('ψ')}"

    " Show buffer number
    let &statusline.="  %{PrettyBufferNumber(bufnr('%'))}  "

    " Filetype
    let &statusline.="%{strlen(&ft)?&ft:'t̶y̶p̶e̶'}."
    " File Encoding
    let &statusline.="%{FileEncoding()}."
    " File Format
    let &statusline.="%{strlen(&ff)?&ff:'f̶o̶r̶m̶a̶t̶'}"
    " Flags
    let &statusline.=" %h%r%w "

    " Right Align From Here
    let &statusline.="%= "
    " Current position as a percentage and total line numbers
    let &statusline.="↕%L·%p"
    " Show location unicode symbol
    let &statusline.="📍 "
    " Column & Line Positon
    let &statusline.="%(%c·%l%)"
    " Switch color to the Comment highlight group
    let &statusline.="%3*"
    " Current Mode
    let &statusline.="%5*%2{PrettyCurrentMode()}  "

    augroup NoticeModeChanges
        au!
        au InsertEnter * call ModeChanged(v:insertmode)
        au InsertChange * call ModeChanged(v:insertmode)
        au InsertLeave * call ModeChanged(mode())
    augroup END
endif
