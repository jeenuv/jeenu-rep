" A collection of VIM settings for Symbian. This file shall be sourced
" either manually or via. an auto command

if exists("b:jeenu_symbian")
    finish
endif

" Indent for function braces too
setl cinoptions+=f1s
" Put { 'shiftwidth' away from the current indent
setl cinoptions+={1s
" Case statements have to have a -ve indent!
setl cinoptions+=:-
" C++ scope statements too to have -ve indent!
setl cinoptions+=g-

" Don't expand tabs
setl noexpandtab
" Set shiftwidth to the default, i.e. 8
setl shiftwidth&vim
" Set soft tab equal to that of tabstop
execute "setl softtabstop=" . &tabstop

" Since Symbian don't keep spaces around operators, it might be
" annoying to see them blended into normal text syntax. So just need
" to color them according to some C operators
syntax match cOperator /[!=<>~+-,]\|\/[^/*]\|\*[^/]/

" Mappings for function browsing
nnoremap <silent> <buffer> ]] :call <SID>SymbianJump('/^\t{')<CR>
nnoremap <silent> <buffer> ][ :call <SID>SymbianJump('/^\t}')<CR>
nnoremap <silent> <buffer> [[ :call <SID>SymbianJump('?^\t{')<CR>
nnoremap <silent> <buffer> [] :call <SID>SymbianJump('?^\t}')<CR>

fun! <SID>SymbianJump(motion) range
    let cnt = v:count1
    let save = @/    " save last search pattern
    mark '
    while cnt > 0
        silent! exe a:motion
        let cnt = cnt - 1
    endwhile
    call histdel('/', -1) " sssh! let no body know we cheated ;)
    let @/ = save    " restore last search pattern
endfun

let b:jeenu_symbian = 1
