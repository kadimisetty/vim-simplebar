" ============================================================================
" File:         simplebar.vim
" Description:  A simple non-attention-seeking status line.
" Maintainer:   Sri Kadimisetty <http://sri.io>
" License:      The MIT License (MIT) {{{
"                   Copyright (c) 2013 Sri Kadimisetty
"                   Permission is hereby granted, free of charge,
"                   to any person obtaining a copy of this
"                   software and associated documentation files
"                   (the "Software"), to deal in the Software
"                   without restriction, including without
"                   limitation the rights to use, copy, modify,
"                   merge, publish, distribute, sublicense, and/or
"                   sell copies of the Software, and to permit
"                   persons to whom the Software is furnished to
"                   do so, subject to the following conditions:
" 
"                   The above copyright notice and this permission
"                   notice shall be included in all copies or
"                   substantial portions of the Software.
" 
"                   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
"                   WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
"                   INCLUDING BUT NOT LIMITED TO THE WARRANTIES
"                   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
"                   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
"                   THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
"                   ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
"                   IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
"                   ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"                   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
"                   SOFTWARE. }}}
"
" Version:      0.3.8
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

"Unfocussed windows:
" "Need to get the colors from the line number per current colorscheme,
" "erroring out w/ this method though
" let line_num_bg = synIDattr(synIDtrans((hlID("LineNr")), "bg")
" let line_num_fg = synIDattr(synIDtrans((hlID("LineNr")), "fg")
" execute 'hi User7 ctermbg='.  line_num_bg 'ctermbg='.  line_num_fg .  'cterm=UNDERLINE'
" "So copping out - hardcoding solarized's colors
if &background ==# "dark" 
    hi User7 ctermbg=0 ctermfg=10 | "cterm=UNDERLINE
    hi VertSplit ctermbg=0 ctermfg=NONE
else
    hi User7 ctermbg=7 ctermfg=14 | "cterm=UNDERLINE
    hi VertSplit ctermbg=7 ctermfg=NONE

endif

" line_num_bg = str2nr(synIDattr(synIDtrans((hlID("LineNr")), "bg"))
" line_num_fg = str2nr(synIDattr(synIDtrans((hlID("LineNr")), "fg"))
" hi User7 ctermbg=line_num_bg ctermfg=line_num_fg cterm=UNDERLINE


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


"Starts initially
function! SetInitialStatusLine()
    let &g:statusline=""
    " Switch color to the User1 highlight group
    let &g:statusline.="%1*"
    " @TODO: 
    "       Use slot in statusline.gutter (spaced equal to gutter-width + foldcolumn-width)
    "       to either show total-lines or buf-number

    " File name
    let &g:statusline.=" %20f"
    " Buffer Modified?
    let &g:statusline.="\ %{&modified==0?'':'+'} "

    " @TODO - Set Read-only flag and show with 🚫
    " Switch color to the User2 highlight group
    let &g:statusline.="%2*"

    " Current git branch
    let &g:statusline.="%{FugitiveStatus('ψ')}  "

    " Filetype
    let &g:statusline.="%{strlen(&ft)?&ft:'t̶y̶p̶e̶'}."
    " File Encoding
    let &g:statusline.="%{FileEncoding()}."
    " File Format
    let &g:statusline.="%{strlen(&ff)?&ff:'f̶o̶r̶m̶a̶t̶'}"
    " Flags
    let &g:statusline.=" %h%r%w "

    " Show buffer number
    let &g:statusline.="%{PrettyBufferNumber(bufnr('%'))}  "

    " Right Align From Here
    let &g:statusline.="%= "

    " Location as- total-number-of-lines and current-line-pos-as-percentage
    let &g:statusline.="↕%L·%p"
    " Show location wit a fancy unicode symbol.
    let &g:statusline.="📍 "
    " Column & Line Positon
    let &g:statusline.="%(%c·%l%)"

    " Switch color to the User3 highlight group
    let &g:statusline.="%3*"
    " Current Mode
    let &g:statusline.="%5*%2{PrettyCurrentMode()}  "

    augroup NoticeModeChanges
        au!
        au InsertEnter * call ModeChanged(v:insertmode)
        au InsertChange * call ModeChanged(v:insertmode)
        au InsertLeave * call ModeChanged(mode())
    augroup END
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
    " 1. Set up the vertical split, with pure color
    set fillchars=vert:\ 
    " 2. Clean up the NonText highlight group
    hi NonText ctermbg=NONE ctermfg=bg

    " 3. Set Initial Status Line
    call SetInitialStatusLine()

    augroup FocusAndUnfocussedStatusLineChanges
        au!
        au WinLeave * call SetUnfocussedStatusLine()
        au WinEnter * call SetStatusLine()
    augroup END
endif
