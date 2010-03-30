" A collection of VIM settings for Symbian. This file shall be sourced
" either manually or via. an auto command

if exists("b:jeenu_symbian")
    finish
endif

" Don't display tabs and trailing spaces
set nolist

" Mappings for function browsing
nnoremap <silent> <buffer> g]] :call <SID>SymbianJump('/^\t{')<CR>
nnoremap <silent> <buffer> g][ :call <SID>SymbianJump('/^\t}')<CR>
nnoremap <silent> <buffer> g[[ :call <SID>SymbianJump('?^\t{')<CR>
nnoremap <silent> <buffer> g[] :call <SID>SymbianJump('?^\t}')<CR>

if !exists("g:symbian_functions_registered")
    function <SID>SymbianJump(motion) range
        let cnt = v:count1
        let save = @/    " save last search pattern
        mark '
        while cnt > 0
            silent! exe a:motion
            let cnt = cnt - 1
        endwhile
        call histdel('/', -1) " sssh! let no body know we cheated ;)
        let @/ = save    " restore last search pattern
    endfunction

    function _SymbSetCodeStyle()
        " Indent for function braces too
        set cinoptions+=f1s
        " Put { 'shiftwidth' away from the current indent
        set cinoptions+={1s
        " C++ scope statements too to have -ve indent!
        set cinoptions+=g-
        " For case statements
        set cinoptions+==0

        " Don't expand tabs
        set noexpandtab
        " Set shiftwidth to the default, i.e. 8
        set shiftwidth=8
        " Set soft tab equal to that of tabstop
        execute "setl softtabstop=" . &tabstop
    endfunction

    function _SymbUnsetCodeStyle()
        set cinoptions&vim
        set expandtab
        set shiftwidth=4
    endfunction

    command SymbSetCodeStyle call _SymbSetCodeStyle()
    command SymbUnsetCodeStyle call _SymbUnsetCodeStyle()

    let g:symbian_functions_registered = 1
endif

" Set coding preferences
call _SymbSetCodeStyle()

let b:jeenu_symbian = 1
