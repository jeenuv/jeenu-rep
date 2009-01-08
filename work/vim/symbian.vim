
if exists("jeenu_symbian")
    echo "Symbian settings already loaded!"
    finish
endif

" Indent for function braces too
set cinoptions+=f1s
" Put { 'shiftwidth' away from the current indent
set cinoptions+={1s
" Case statements have to have a -ve indent!
set cinoptions+=:-
" C++ scope statements too to have -ve indent!
set cinoptions+=g-

" Don't expand tabs
set noexpandtab
" Set shiftwidth to the default, i.e. 8
set shiftwidth&vim
" Set soft tab equal to that of tabstop
execute "set softtabstop=" . &tabstop

let jeenu_symbian = 1
echo "Symbian settings loaded!"
