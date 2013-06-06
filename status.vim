"Settings
"
"Always show the status bar
set laststatus=2 
let g:last_mode=""


"Set the status line
function! SetStatusLine()
    let &statusline=""
    let &statusline.="%#LineNr#"
    let &statusline.=" "
    let &statusline.="%10f"
    let &statusline.="\ %{&modified==0?'':'❗'} "
    let &statusline.="%#Comment#"
                   
    let &statusline.=" "
    let &statusline.="ψ master "
    let &statusline.="%{strlen(&ft)?&ft:'nofilet'}."
    let &statusline.="%{&ff}."
    let &statusline.="%{FileEncoding()} "
                   
    let &statusline.="%=
    let &statusline.=" %5(%c·%l%)"
    let &statusline.="📍 "
    let &statusline.=" %P%L"
    let &statusline.="%h%m%r%w" 
    let &statusline.="%#Statement#"
    let &statusline.="%3{CurrentMode()}  "
endfunction


"Use a symbol to indicate few modes
function! CurrentMode()
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

