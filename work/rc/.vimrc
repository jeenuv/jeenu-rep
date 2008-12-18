
" Jeenu's VIMRC

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set nocompatible                                        " Use Vim settings, rather then Vi settings (much better!).

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
endif

set autoindent                                          " always set autoindenting on
set nobackup                                            " keep no backup for the files saved
set history=50                                          " keep 50 lines of command line history
set ruler                                               " show the cursor position all the time
set showcmd                                             " display incomplete commands
set incsearch                                           " do incremental searching
set backspace=indent,eol,start                          " allow backspacing over everything in insert mode
set number                                              " display line numbers
set shiftwidth=4                                        " Indenting width when using < and > commands
set softtabstop=4
set expandtab                                           " Convert tabs to spaces
set textwidth=135
set list                                                " Display tabs and trailing spaces
set listchars=tab:>-,trail:~
set confirm                                             " confirm most of the actions
set previewheight=10                                    " Height of preview window
set showmatch                                           " show matching braces while typing
set diffopt=filler                                      " Ignore whitespace when diffing
set nowrapscan                                          " Don't wrap searches
set autoread                                            " Read changed files automatically
set splitright                                          " place new window to the right of the current one when doing vertical splitting
set virtualedit=all                                     " Enable virtual editing
set ignorecase                                          " Ignore the case for tag-matching!
set nostartofline                                       " Don't move the cursor from the current columnt after move commands
set t_Co=256                                            " No. of terminal colors
set cmdwinheight=15                                     " Command line window height
set selection=inclusive                                 " Selection is inclusive
" Remove = from filename characters so that we are able to
" autocomplete variable assignments, especially in shell
set isf-==
" This is ONLY for the console mode; When Vim enters the GUI mode
" it resets all termcap codes. So it's not applicable for GUI!
set vb                                                  " No bell
set t_vb=
" Ignore these suffixes when completing in command-line. These
" are added in multiple lines, since the doc recommends so
set wildignore+=*.o
set wildignore+=*.obj
set wildignore+=*.a
set wildignore+=*.so
" Setting this option gives you menu when doing auto-completion. Use arrow keys
" to select the desired item!
set wildmenu

" Options for GUI/Terminal
if has("gui_running")
    " Select the torte coloscheme for GUI
    colorscheme torte

    " When GUI mode is entered, set the terminal code for Visual Bell
    if has("autocmd") && has("gui") && v:version >= 700
        autocmd GUIEnter * call OnGUIEnter()
    endif

    if has("gui_win32")
        " Select my favourite Courier New font :)
        set guifont=Courier:h12:cANSI
    elseif has("gui_gtk")
        " Linux might not have the Courier New; and monospace looks better too
        set guifont=Monospace\ 10
    endif

    " Let the Window system manage the ALT keys
    set winaltkeys=yes

    " Settings for Windows
    if has("win32")
        " Who need those windows mappings?
        silent! unmap  <C-Y>
        silent! unmap  <C-V>
        silent! unmap  <C-Z>

        silent! iunmap <C-Y>
        silent! iunmap <C-A>
        silent! iunmap <C-V>
        silent! cunmap <C-V>

        " Use forward slashes on filename completion
        set shellslash
    endif
else
    " Currently selected colorscheme; doesn't look bad
    colorscheme desert
endif

" *****************************************************
" ****************** KEY MAPPINGS *********************
" *****************************************************

" Use bash style cursor movements
imap <C-F> <C-O>l|              " Cursor movements as in Bash
imap <C-B> <C-O>h|

nmap <F8> <C-W>g}|              " Look up the tag in the preview window
nmap <F2> :ls<CR>:b|            " Lists the open buffers
nmap K <NOP>|                   " Get rid of the annoying man page lookup

nnoremap <C-L> <C-L>:noh<CR>|   " Kinda refresh

" Process when Enter Key is pressed
nmap <CR> :call OnReturnKey()<CR>:echo<CR>|

nmap - O<ESC>|                  " Insert a new line at the cursor postion
nmap <SPACE> i <ESC>l|          " Inser a space in normal mode

nmap \c ^i/* <ESC>$a */<ESC>|               " For commenting out a single line
nmap \uc ^3x$xhxhx|                         " For uncommenting a single line
nmap \s i <ESC>2li <ESC>h|                  " For inserting space on both sides of a character
nmap \j :tag /Java_.*<C-R><C-W>|            " For searching for a Java native implementation tag

" Mapping to do <C-T> on a separate window so that you can see both caller and
" callee in separate windows
nmap <C-W><C-T> :sp<CR><C-T>

" Mapping to close the tag
nmap <C-W>Q :tabc<CR>

" Highlighting mappings. To undo these highligting, do :mat
nmap \h yiw:call DoHighlight(1)<CR>|         " Normal mode highlighting
vmap \h y:call DoHighlight()<CR>|            " Visual mode highlighting
nmap \uh :call UndoHighlight()<CR>|

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
vnoremap p "_dp

" Ctrl-& (may be same as ctrl-_) for alternate tab
" See Autocommand for TabLeave and TabEnter events
let g:J_old_tab = 1
let g:J_new_tab = 1
nmap <C-_> :execute "tabnext " . g:J_old_tab<CR>
imap <C-_> <ESC>:execute "tabnext " . g:J_old_tab<CR>

" Use C-N and C-P for page navigation in Normal mode
nmap <C-N> <C-F>
nmap <C-P> <C-B>

nnoremap d} 0d}|                "Delete a section

" Simulating the arrowkeys in command line
cmap <C-P> <Up>
cmap <C-N> <Down>
cmap <C-Z> <Left>
cmap <C-X> <Right>

" Search using visual selection
vmap * y/\<<C-R>=escape("<C-R>"", "$.*/~[]?")<CR>\><CR>
vmap # y?\<<C-R>=escape("<C-R>"", "$.*/~[]?")<CR>\><CR>

vmap g* y/<C-R>=escape("<C-R>"", "$.*/~[]?")<CR><CR>
vmap g# y?<C-R>=escape("<C-R>"", "$.*/~[]?")<CR><CR>

" Wrap selection with selected character
vmap \w :call GetWrapperChoiceFromUser()<CR>

" ****************************************************
" *************** TERMINAL SETTINGS ******************
" ****************************************************

" The termcap entry for screen doesn't seem to have the <S-Tab> entry.
" And hence pressing that key caused VIM to behave as if <ESC> was pressed
if &term == "screen" && !has('gui_running')
    exe "set <S-Tab>=\e[Z"
endif

" In some terminals, pressig <BS> key will just echo ^?
set <BS>=

" ****************************************************
" ***************** AUTO COMMANDS ********************
" ****************************************************

" Put these in an autocmd group, so that we can delete them easily.
if has("autocmd")
    augroup vimrcJeenu
        " Delete all auto commands in this group first
        au!

        " This is required to prevent help files being treated
        " as normal help files
        autocmd BufReadPost *.txt
            \ if &ft == "" |
            \   setf text |
            \ endif

        " For all text files set 'textwidth' to 80 characters.
        " Allow formatting of numbered/bulleted lists
        " I don't want comment leaders being inserted!
        autocmd FileType text
                    \ setlocal textwidth=80 |
                    \ set formatlistpat=^\\s*\\%(\\d\\+[]:.)}\\t\ ]\\\|[*ox-]\\)\\s* |
                    \ set formatoptions=tn |
                    \ set comments= commentstring=

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal g`\"" |
                    \ endif

        " Auto commands for XML
        autocmd BufNew,BufEnter *.svg setf xml|set matchpairs=<:>

        " Auto commands for makefiles
        autocmd BufNew,BufEnter *.gmk,*.make setf make

        " Auto commands for C files to set tw to 100
        autocmd BufNew,BufEnter *.[ch],*.[ch][xp][xp] set textwidth=100

        " Auto command helpers for switching to alternate tabs
        if v:version >= 700
            autocmd TabLeave * let g:J_old_tab = tabpagenr()
            autocmd TabEnter * let g:J_new_tab = tabpagenr()
        endif
    augroup END
endif

" ****************************************************
" ******************* COMMANDS ***********************
" ****************************************************

" For trucating trailing whitespace
command! TruncW :%s/\s\+$//ce |

" For doing a diff on the BASE version from within Vim
command! SVNBaseDiff   execute "!svn diff % > ~/tmp/svnpatchfile"|
                     \ set patchexpr=MyPatch()|
                     \ vert diffp ~/tmp/svnpatchfile|
                     \ windo set fdm=diff|
                     \ set patchexpr&|
                     \ wincmd p

" Command for entering navigation choice
command! -nargs=? SetNavChoice call GetNPNavigatonChoiceFromUser("<args>")

" Command for preparing SVN commit. This command is expected to be issed from a vim
" window obtained after presseing C-x C-e in bash
command! -nargs=0 PrepareSVNCommit call PrepareSVNCommit()

" For aligning lines left or right w.r.t to a vertical selectin
command! -range -nargs=1 Align call AlignVert("<args>")

" Insert a (possibly) unique timestamp
command -nargs=0 -count=1 Timestamp call InsertTimestamp("<count>")

if has("unix")
    " Get all the files in the current directory and then wrap them in quotes.
    " This is intended to be used with C-x C-e command in bash
    command -nargs=0 WrapLines    set nohls|
                                \ silent 2,$s/\%(^\|$\)/'/g|
                                \ silent 1,$-1s/$/ \\/g|
                                \ normal gg
endif

" ****************************************************
" ****************** FUNCTIONS ***********************
" ****************************************************

"Convert tabs to spaces
function TabsToSpace()
    if v:version >= 700
        " Use the repeat function for later versions of vim
        let l:Subs = repeat(" ", &shiftwidth)
    else
        " Else simulate repeat() function
        let l:Subs = ""
        let l:Index = 0

        " Get the correct number of spaces to substitute
        while l:Index < &shiftwidth
            let l:Subs = (l:Subs . " ")
            let l:Index = l:Index + 1
        endwhile
    endif

    let l:Command = "%s/\\t/" . l:Subs . "/gce"
    execute l:Command
    echo "Tabs converted to " . &shiftwidth . " spaces!"
endfunction

" Function to be executed when I press <CR> key. This is for
" for fact that, I need an empty line to be inserted in normal
" mode, also a command to be executed when I'm in a history window
function OnReturnKey()
    if &modifiable != 1 || &buftype == "nofile" || &buftype == "quickfix"
        " From command line history window (and the like), Need to
        " execute the command when the <CR> is pressed
        execute "normal! \<CR>"
    else
        " Else insert a blank line
        normal o
    endif
endfunction

" Obtain what the user want to do when C-N and C-P are pressed
function! GetNPNavigatonChoiceFromUser(...)
    if a:0 == 0 || a:1 == ""
        let l:choice = input("Enter a choice (p/t/c/l/d/a/g): ")
    else
        let l:choice = a:1
    endif

    if l:choice ==? "p" || l:choice == 1
        nmap <C-N> <C-F>
        nmap <C-P> <C-B>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif l:choice ==? "t" || l:choice == 2
        if v:version >= 700
            " Tab's were added after 700
            " tabnext does't accept a count, I've to work this around
            nmap <C-N>  :<C-U>
                        \let g:J_count = v:count1<bar>
                        \while g:J_count > 0<bar>
                        \    tabnext<bar>
                        \    let g:J_count -= 1<bar>
                        \endwhile<CR>
            nmap <C-P> :<C-U>execute "tabprevious " . v:count1<CR>
        else
            silent! nunmap <C-N>
            silent! nunmap <C-P>
        endif

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif l:choice ==? "c" || l:choice == 3
        " Navigate error list
        nmap <C-N> :<C-U>execute "keepju " . v:count . "cnext"<CR>
        nmap <C-P> :<C-U>execute "keepju " . v:count . "cprevious"<CR>

        nmap g<C-N> :<C-U>execute v:count . "cnewer"<CR>
        nmap g<C-P> :<C-U>execute v:count . "colder"<CR>
    elseif l:choice ==? "l" || l:choice == 4
        " Navigate location list
        nmap <C-N> :<C-U>execute "keepju " . v:count . "lnext"<CR>
        nmap <C-P> :<C-U>execute "keepju " . v:count . "lprevious"<CR>

        nmap g<C-N> :<C-U>execute v:count . "lnewer"<CR>
        nmap g<C-P> :<C-U>execute v:count . "lolder"<CR>
    elseif l:choice ==? "d" || l:choice == 5
        " Navigate diffs in file
        nmap <C-N> ]c
        nmap <C-P> [c

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif l:choice ==? "a" || l:choice == 6
        " Navigate arguments
        nmap <C-N> :next<CR>
        nmap <C-P> :previous<CR>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif l:choice ==? "g" || l:choice == 7
        " Navigate tags
        nmap <C-N> :tn<CR>
        nmap <C-P> :tp<CR>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif l:choice == ""
        return
    else
        echohl Error
        echo "Invalid Input!"
        echohl None
        return
    endif
endfunction

" Function to obtain a character from user, when the he decides to wrap
" the selection with (,{,[,",' etc.
function! GetWrapperChoiceFromUser() range
    let l:charmap = { "(" : ")", "{" : "}", "[" : "]", "<" : ">" }
    let l:choice = input("Enter a string to wrap: ")

    " Try getting the pair
    try
        let l:pair = l:charmap[l:choice]
    catch /E716/
        " If it doens't have a pair, use the choice itself
        let l:pair = l:choice
    catch /E713/
        " Either entered nothing, or pressed <ESC>
        normal `<
        return
    endtry

    " Now wrap the selection with the selected character and it's pair
    execute "normal `>a" . l:pair . "\<ESC>`<i" . l:choice . "\<ESC>"
endfunction

" Function for preparing an SVN commit. Just do PrepareSVNCommit command and
" you'll get the list of files eligible for commit
function! PrepareSVNCommit()
    set tw=80                          " Set text width to 80
    set ft=sh|                         " Set sh filetype for clarity
    normal isvn ci
    silent r !svn st
    2,$yank a                                 " Yank the svn st output to register a
    silent g/^[?~]/delete                     " Delete the unversioned items from commit list
    silent 2,$g/.*/normal 6x/                 " Delete all the flags infront of files
    silent g/^ +/s/^ +\s\+/ /                 " Remove the '+' in the fourth column too
    silent g/.*/s/$/ \\/                      " Append all lines with a \
    silent execute "normal Go\<C-U>-m \"\\\<ESC>ma2o"

    " For the sake of clarity, just put the actual output of svn st at
    " the bottom in comments
    execute "normal o# -- This was the unfiltered output of 'svn st' --"
    " Now comment out all the svn st output
    silent put a
    normal '[
    silent .,$s/^/# /

    " Place the curosor where you've to enter the commit log
    normal 'ajr"
endfunction

" Function to be called upon entering GUI mode
function! OnGUIEnter()
    set t_vb=
    nmap <C-?> :execute "tabnext " . g:J_old_tab<CR>
endfu

" Function to do highlighting. This adds pattern to the highlighting array
function! DoHighlight(...)
    if !exists("w:J_highlighting")
        let w:J_highlighting = []
    endif

    if @" != ""
        if a:0 > 0 && a:1 == 1
            let l:case_s = "\\<"
            let l:case_e = "\\>"
        else
            let l:case_s = ""
            let l:case_e = ""
        endif

        " Get the text, escape and insert to the list, so that it'll becomes a LIFO
        let l:text = escape(@", "$.*/~[]")
        call add(w:J_highlighting, l:case_s . l:text . l:case_e)
    endif

    " Now create the match command with all of the items in the list
    let l:i = 0
    let l:num_items = len(w:J_highlighting)

    let l:pattern = ""
    while l:i < l:num_items
        let l:pattern = l:pattern . w:J_highlighting[l:i]

        " Append a \|, but for the last element in the list
        if l:i < (l:num_items - 1)
            let l:pattern = l:pattern . "\\|"
        endif

        let l:i = l:i + 1
    endwhile

    " Finally run the match command
    if l:pattern == ""
        match
    else
        execute "match Todo /" . l:pattern . "/"
    endif
endfu

" Function to undo highlighting. Uses the w:J_highlighting global varible
function! UndoHighlight()
    if !exists("w:J_highlighting") || 0 == len(w:J_highlighting)
        echo "Nothing to unhighlight"
        return
    endif

    let l:i = 0
    let l:num_items = len(w:J_highlighting)

    " Clear all option
    let l:item = printf("%2d: %s", 0, "<ALL>")
    echo l:item

    while l:i < l:num_items
        let l:item = printf("%2d: \"%s\"", l:i + 1, w:J_highlighting[l:i])
        echo l:item

        let l:i = l:i + 1
    endwhile

    let l:choice = input("Select a string to unhilight: ")
    if l:choice == ""
        return
    elseif l:choice == 0
        " Clear highlighting and reset list
        match
        let w:J_highlighting = []
    else
        " Try to get the element
        if get(w:J_highlighting, l:choice - 1, "ERROR") == "ERROR"
            return
        else
            call remove(w:J_highlighting, l:choice - 1)

            " If this isn't empty, DoHighlight() will try to add highlighting
            let @" = ""
            call DoHighlight()
        endif
    endif
endfu

" Function to alingn lines -- either left or right -- to a vertical line; just like a magnet.
function! AlignVert(direction) range
    if a:direction !=? "l" && a:direction !=? "r"
        echo "Invalid direction"
        return
    elseif &ve != "all"
        echo "'ve' is not set to all"
        return
    endif

    let l:cur_start = getpos("'<")
    let l:cur_end   = getpos("'>")

    " Sanity checks. We've to consider the offset since 've' is set
    if l:cur_start[1] == 0 ||
                \ l:cur_start[2] == 0 ||
                \ l:cur_end[1] == 0 ||
                \ l:cur_end[2] == 0
        echo "No visual selection made"
        return
    elseif (l:cur_start[2] + l:cur_start[3]) != (l:cur_end[2] + l:cur_end[3])
        echo "You've to make a single-column vertical selection"
        return
    endif

    " Got to the first column
    normal `<
    let l:i = 0

    if a:direction ==? "l"
        for l:i in range(l:cur_start[1], l:cur_end[1])
            normal dwj
        endfor
    elseif a:direction ==? "r"
        let l:shift = input("Shift from start of line (y/n)? ", "n")
        if l:shift !=? "n" && l:shift !=? "y"
            echo "Invalid input"
            return
        elseif l:shift ==? "n"
            let l:move_cmd = input("Enter the command to select dragging point: ", "1B")
            if l:move_cmd !~? "^\\d*b$"
                let l:move_cmd = "B"
            endif
        endif

        " Save and later restore the marks
        let l:save_a = getpos("'a")
        let l:save_b = getpos("'b")
        let l:save_c = getpos("'c")

        for l:i in range(l:cur_start[1], l:cur_end[1])
            if l:shift ==? "n"
                execute "normal ma" . l:move_cmd . "mb$mclv`ar `bv`cd$p`aj"
            else
                normal ma^mb$mclv`ar `bv`cd$p`aj
            endif
        endfor

        call setpos("'a", l:save_a)
        call setpos("'b", l:save_b)
        call setpos("'c", l:save_c)
    endif
endfu

" Function to insert a (possibly) unique time stamp. This can be used to refer to other locations in
" the code obviating the need for line-no. and similar references
function! InsertTimestamp(count) range
    let l:count = a:count
    let l:cursor_pos = getpos(".")

    if !executable("uuidgen") || !executable("awk")
        echo "Couldn't find necessary executables"
        return
    endif

    while l:count > 0
        " This will insert the timestamp onto a new line; hence we've to join lines
        execute "r !uuidgen | awk -F- '{printf $NF}'"

        let l:count = l:count -1
    endwhile

    if a:count == 1
        " Only one to insert; and let it remain inline ;)
        normal diw"_dd
        call setpos(".", l:cursor_pos)
        normal gP
    else
        " We just inserted the last timestamp; now move to where we were
        call setpos(".", l:cursor_pos)
    endif
endfu

" To generage patch for SVN. This is used in SVNBaseDiff command as well as
" showbasediff shell script
function MyPatch()
    call system("patch -R -o " . v:fname_out . " " . v:fname_in . " < " .  v:fname_diff)
endfunction

" ****************************************************
" ***************** END FUNCTIONS ********************
" ****************************************************

" for the diff mode
if &diff
    call GetNPNavigatonChoiceFromUser("d")
    cmap q qa
endif

" All set, now search and source the local file and source.
" it This file is supposed to contain the system-dependent settings for VIM
if filereadable($HOME . "/.vimrc.local")
    exe "source " . $HOME . "/.vimrc.local"
endif
