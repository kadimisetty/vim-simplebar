" ============================================================================
" File:         simplebar.vim
" Description:  A simple non-attention-seeking Vim status line.
" Maintainer:   Sri Kadimisetty <http://sri.io>
" License:      GNU LESSER GENERAL PUBLIC LICENSE, Version 3, 29 June 2007
" Version:      0.3.3
" ============================================================================


if exists("g:loaded_simplebar_plugin") || &compatible || v:version < 700
    echo "needs to be above or equal to version 7.3"
    finish
endif
let g:loaded_simplebar_plugin = 1

"Dev settings
nnoremap <leader>sl :call SetStatusLine()<CR>
nnoremap <leader>st :source %<CR>

"Always show the status bar
set laststatus=2 
"let g:last_mode=""


"Colors 
hi default link User1 LineNr
hi default link User2 Comment
hi default link User3 Statement
hi User5 ctermfg=LightGreen ctermbg=NONE cterm=bold


" Change the User1 highlight group values based on mode
function! s:ModeChanged(mode)
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
function! s:PrettyCurrentMode()
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

"Return file enoding used amd tell if theres a DOS bom
function! s:FileEncoding()
    if &fenc !~ "^$\|utf-8" || &bomb
        return &fenc . (&bomb ? "-bom" : "" )
    else
        return ""
    endif
endfunction

" @TODO - Allow configurable option for buffer number style
" Return Pretty Buffer Numbers
function! s:PrettyBufferNumber(current_buffer_number)
    let l:encircled_numers_negative = [
                \ "➊ ", "➋ ", "➌ ", "➍", "➎ ",
                \ "➏ ", "➐ ", "➑", "➒ ", "➓ ",
                \ "⓫", "⓬", "⓭", "⓮", "⓯",
                \ "⓰", "⓱", "⓲", "⓳", "⓴", 
                \  ]
    let l:bracketed_numbers = [
                \ "⑴", "⑵", "⑶", "⑷", "⑸",
                \ "⑹", "⑺", "⑻", "⑼", "⑽",
                \ "⑾", "⑿", "⒀", "⒁", "⒂",
                \ "⒃", "⒄", "⒅", "⒆", "⒇"
                \ ]
    let l:encircled_numbers = [ 
                \ "①", "②", "③", "④", "⑤",
                \ "⑥", "⑦", "⑧", "⑨", "⑩", 
                \ "⑪", "⑫", "⑬", "⑭", "⑮", 
                \ "⑯", "⑰", "⑱", "⑲", "⑳"
                \ ]
    let l:pretty_numbers = l:encircled_numbers
    if a:current_buffer_number < len(l:pretty_numbers)
        return l:pretty_numbers[a:current_buffer_number-1]
    else
        return a:current_buffer_number
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
    let &statusline.="\ %{&modified==0?'':'✏'} "

    " @TODO - Set Read-only flag and show with 🚫

    " Switch color to the Comment highlight group 
    let &statusline.="%2*"
    
    " @TODO: Fugitive support to get curent branch name etc.
    " let &statusline.=" ψ master "

    " Show buffer number
    let &statusline.=" %{s:PrettyBufferNumber(bufnr('%'))}"
    " Filetype
    let &statusline.=" %{strlen(&ft)?&ft:'no ft'}."
    " File Format
    let &statusline.="%{&ff}."
    " File Encoding
    let &statusline.="%{s:FileEncoding()} "
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
    let &statusline.="%5*%2{s:PrettyCurrentMode()}  "

    au InsertEnter * call ModeChanged(v:insertmode)
    au InsertChange * call ModeChanged(v:insertmode)
    au InsertLeave * call ModeChanged(mode())

    vnoremap <expr> <SID>CursorLineNrColorVisual CursorLineNrColorVisual()
    nnoremap <script> v v<SID>CursorLineNrColorVisual
    nnoremap <script> V V<SID>CursorLineNrColorVisual
    nnoremap <script> <C-v> <C-v><SID>CursorLineNrColorVisual
endif
