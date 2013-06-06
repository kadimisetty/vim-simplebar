"Settings
nnoremap <leader>sl :call SetStatusLine()<CR>
nnoremap <leader>st :source %<CR>
"
"Always show the status bar
set laststatus=2 
let g:last_mode=""


"Set the status line
function! SetStatusLine()
    let &statusline=""
    " Switch color to the LineNr highlight group
    let &statusline.="%#LineNr#"
    " let &statusline.="  ⒙" | "🚫
    
    " @TODO: %L matched with gutter width + fold column width

    " File name
    let &statusline.=" %f"

    " Modified Buffer?
    let &statusline.="\ %{&modified==0?'':'❗'} "

    " Switch color to the Comment highlight group
    let &statusline.="%#Comment#"
    
    
    " @TODO: Add fugitive support to get curent branch name etc.
    " Show the git branch 
    " let &statusline.=" ψ master "
    
    " Filetype
    let &statusline.=" %{strlen(&ft)?&ft:'nofilet'}."
    " File Format
    let &statusline.="%{&ff}."
    " File Encoding
    let &statusline.="%{FileEncoding()} "
                   
    " Show buffer number
    let &statusline.=" %{PrettyBufferNumber(bufnr('%'))}"

    " Right Align From Here
    let &statusline.="%= "
    " Current position as a percentage and total line numbers
    let &statusline.="↕%L·%p"
    " Show location unicode symbol
    let &statusline.="📍 "
    " Column & Line Positon
    let &statusline.="%(%c·%l%)"

    " Flags
    let &statusline.="%h%r%w" 
    " Switch color to the Comment highlight group
    let &statusline.="%#Statement#"
    " Current Mode
    let &statusline.="%2{PrettyCurrentMode()}  "
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


"Return file enoding used amd tell if theres a DOS bom
function! FileEncoding()
    if &fenc !~ "^$\|utf-8" || &bomb
        return &fenc . (&bomb ? "-bom" : "" )
    else
        return ""
    endif
endfunction


function! PrettyBufferNumber(current_buffer_number)
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
    let l:pretty_numbers = l:bracketed_numbers
    if a:current_buffer_number < len(l:pretty_numbers)
        return l:pretty_numbers[a:current_buffer_number-1]
    else
        return a:current_buffer_number
    endif
endfunction
