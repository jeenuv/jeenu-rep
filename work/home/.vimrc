
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

" This set so that I can run :ru jeenu/some.vim so that I get my desired settings
set runtimepath+=~/.vim

" Make tab lines in my way!
set tabline=%!MakeTabLine()

" I want to use mouse everywhere
set mouse=a

" Don't litter swp files
set updatecount=0

" If running under Cygwin, we need to add \ to file name characters
if $PATH =~? "/cygdrive"
    set isf+=\\
endif

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

    " I don't want tool and menu bars!
    set guioptions-=m
    set guioptions-=T

    " I don't want any scroll bars either
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L

    " Set the default height of GVim window
    set lines=35
    set columns=90

    " Set GUI tab label. This has got similar, but different usage than
    " 'tabline'. See help for details
    " 7d0ec10437cd
    set guitablabel=%!GetTabFileName(tabpagenr())
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

" Kinda refresh
nnoremap <C-L> :noh\|if &diff\|diffupdate\|endif<CR><C-L>

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
vmap * y/\<<C-R>=escape('<C-R>"', '$.*/~[]\')<CR>\><CR>
vmap # y?\<<C-R>=escape('<C-R>"', '$.*/~[]\')<CR>\><CR>

vmap g* y/<C-R>=escape('<C-R>"', '$.*/~[]\')<CR><CR>
vmap g# y?<C-R>=escape('<C-R>"', '$.*/~[]\')<CR><CR>

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

        " For all text files set 'textwidth' to 78 characters.
        " Allow formatting of numbered/bulleted lists
        " I don't want comment leaders being inserted!
        autocmd FileType text
                    \ setlocal textwidth=78 |
                    \ set formatlistpat=^\\s*\\%([A-Za-z]\\\|[0-9]\\+\\\|[*-]\\)[]:.)}\\t\ ]\\s* |
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
        autocmd BufNew,BufEnter *.[ch],*.[ch][xp][xp],*.vim set textwidth=100

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

" For doing an SVN diff on the BASE version from within Vim
command! SVNBaseDiff execute "!svn diff % > ~/tmp/patchfile"|
                    \ call DoMyDiff()

" For doing a Git diff within Vim. Need the --cached option because index is populated
" already, without which git diff will give empty output
command! GitDiff execute "!git diff --cached -p --no-prefix --no-ext-diff -- % > ~/tmp/patchfile"|
                    \ call DoMyDiff()

" Command for entering navigation choice
command! -nargs=? SetNavChoice call GetNPNavigatonChoiceFromUser("<args>")

" Command for preparing SVN commit. This command is expected to be issed from a vim
" window obtained after presseing C-x C-e in bash
command! -nargs=0 PrepareSVNCommit call PrepareSVNCommit()

" For aligning lines left or right w.r.t to a vertical selectin
command! -range -nargs=1 Align call AlignVert("<args>")

" Insert a (possibly) unique timestamp
command -nargs=0 -count=1 Timestamp call InsertTimestamp("<count>")

" Toggles the tabline to contained chopped full-path or just basename
let g:J_TablineFullPath = 0
command -nargs=0 ToggleTabline call ToggleTabline()|normal <C-L>

if has("unix")
    " Get all the files in the current directory and then wrap them in quotes.
    " This is intended to be used with C-x C-e command in bash
    command -nargs=0 WrapLines    silent 2,$s/"/\\"/ge |
                                \ silent 2,$s/\%(^\|$\)/"/g |
                                \ silent 1,$-1s/$/ \\/g |
                                \ noh |
                                \ normal gg
endif

" ****************************************************
" ****************** FUNCTIONS ***********************
" ****************************************************

" Common diff code
function DoMyDiff()
    set patchexpr=MyPatch()                  " Custom patching ;D
    vert diffp ~/tmp/patchfile
    windo set fdm=diff
    set patchexpr&
    autocmd BufWinLeave <buffer> diffoff     " Saves me a manual diffoff
    wincmd p                                 " Go to the actual buffer
endfunction

"Convert tabs to spaces
function TabsToSpace()
    if v:version >= 700
        " Use the repeat function for later versions of vim
        let subs = repeat(" ", &shiftwidth)
    else
        " Else simulate repeat() function
        let subs = ""
        let index = 0

        " Get the correct number of spaces to substitute
        while index < &shiftwidth
            let subs .= " "
            let index += 1
        endwhile
    endif

    let command = "%s/\\t/" . subs . "/gce"
    execute command
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
        let choice = input("Enter a choice (p/t/c/l/d/a/g): ")
    else
        let choice = a:1
    endif

    if choice ==? "p"
        nmap <C-N> <C-F>
        nmap <C-P> <C-B>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif choice ==? "t"
        if v:version >= 700
            " Tab's were added after 700
            " tabnext does't accept a count, I've to work this around
            nmap <C-N>  :<C-U>
                        \ let g:J_count = v:count1<bar>
                        \ while g:J_count > 0<bar>
                        \     tabnext<bar>
                        \     let g:J_count -= 1<bar>
                        \ endwhile<CR>
            nmap <C-P> :<C-U>execute "tabprevious " . v:count1<CR>
        else
            silent! nunmap <C-N>
            silent! nunmap <C-P>
        endif

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif choice ==? "c"
        " Navigate error list
        nmap <C-N> :<C-U>execute "keepju " . v:count . "cnext"<CR>
        nmap <C-P> :<C-U>execute "keepju " . v:count . "cprevious"<CR>

        nmap g<C-N> :<C-U>execute v:count . "cnewer"<CR>
        nmap g<C-P> :<C-U>execute v:count . "colder"<CR>
    elseif choice ==? "l"
        " Navigate location list
        nmap <C-N> :<C-U>execute "keepju " . v:count . "lnext"<CR>
        nmap <C-P> :<C-U>execute "keepju " . v:count . "lprevious"<CR>

        nmap g<C-N> :<C-U>execute v:count . "lnewer"<CR>
        nmap g<C-P> :<C-U>execute v:count . "lolder"<CR>
    elseif choice ==? "d"
        " Navigate diffs in file
        nmap <C-N> ]c
        nmap <C-P> [c

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif choice ==? "a"
        " Navigate arguments
        nmap <C-N> :next<CR>
        nmap <C-P> :previous<CR>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif choice ==? "g"
        " Navigate tags
        nmap <C-N> :tn<CR>
        nmap <C-P> :tp<CR>

        silent! nunmap g<C-N>
        silent! nunmap g<C-P>
    elseif choice == ""
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
    let charmap = { "(" : ")", "{" : "}", "[" : "]", "<" : ">" }
    let choice = input("Enter a string to wrap: ")
    let length = len(choice)
    let pair = ""
    let index = 0

    while index < length
        " Try getting the pair
        try
            let pair .= charmap[choice[index]]
        catch /E716/
            " If it doens't have a pair, use the choice itself
            let pair .= choice[index]
        catch /E713/
            " Either entered nothing, or pressed <ESC>
            normal `<
            return
        endtry

        let index = index + 1
    endwhile

    " Now wrap the selection with the selected character and it's pair
    execute "normal `>a" . pair . "\<ESC>`<i" . choice . "\<ESC>"
endfunction

" Function for preparing an SVN commit. Just do PrepareSVNCommit command and
" you'll get the list of files eligible for commit
function! PrepareSVNCommit()
    if ! isdirectory(".svn")
        echo getcwd() . " is not an SVN WC"
        return 1
    endif

    set tw=80                          " Set text width to 80
    set ft=sh|                         " Set sh filetype for clarity
    normal isvn ci
    silent r !svn st -q
    2,$yank a                                 " Yank the svn st output to register a
    silent g/^[?~]/delete                     " Delete the unversioned items from commit list
    silent 2,$g/.*/normal 6x/                 " Delete all the flags infront of files
    silent g/^ +/s/^ +\s\+/ /                 " Remove the '+' in the fourth column too
    silent g/.*/s/$/ \\/                      " Append all lines with a \
    silent execute "normal Go\<C-U>-m \"\\\<ESC>ma2o"

    " For the sake of clarity, just put the actual output of svn st at
    " the bottom in comments
    execute "normal o# -- This was the unfiltered output of 'svn st -q' --"
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
endfunction

" Function to do highlighting. This adds pattern to the highlighting array
function! DoHighlight(...)
    if !exists("w:J_highlighting")
        let w:J_highlighting = []
    endif

    if @" != ""
        if a:0 > 0 && a:1 == 1
            let case_s = "\\<"
            let case_e = "\\>"
        else
            let case_s = ""
            let case_e = ""
        endif

        " Get the text, escape and insert to the list, so that it'll becomes a LIFO
        let text = escape(@", "$.*/~[]")
        call add(w:J_highlighting, case_s . text . case_e)
    endif

    " Now create the match command with all of the items in the list
    let i = 0
    let num_items = len(w:J_highlighting)

    let pattern = ""
    while i < num_items
        let pattern .= w:J_highlighting[i]

        " Append a \|, but for the last element in the list
        if i < (num_items - 1)
            let pattern .= "\\|"
        endif

        let i += 1
    endwhile

    " Finally run the match command
    if pattern == ""
        match
    else
        execute "match Todo /" . pattern . "/"
    endif
endfunction

" Function to undo highlighting. Uses the w:J_highlighting global varible
function! UndoHighlight()
    if !exists("w:J_highlighting") || 0 == len(w:J_highlighting)
        echo "Nothing to unhighlight"
        return
    endif

    let i = 0
    let num_items = len(w:J_highlighting)

    " Clear all option
    let item = printf("%2d: %s", 0, "<ALL>")
    echo item

    while i < num_items
        let item = printf("%2d: \"%s\"", i + 1, w:J_highlighting[i])
        echo item

        let i = i + 1
    endwhile

    let choice = input("Select a string to unhilight: ")
    if choice == ""
        return
    elseif choice == 0
        " Clear highlighting and reset list
        match
        let w:J_highlighting = []
    else
        " Try to get the element
        if get(w:J_highlighting, choice - 1, "ERROR") == "ERROR"
            return
        else
            call remove(w:J_highlighting, choice - 1)

            " If this isn't empty, DoHighlight() will try to add highlighting
            let @" = ""
            call DoHighlight()
        endif
    endif
endfunction

" Function to alingn lines -- either left or right -- to a vertical line; just like a magnet.
function! AlignVert(direction) range
    if a:direction !=? "l" && a:direction !=? "r"
        echo "Invalid direction"
        return
    elseif &ve != "all"
        echo "'ve' is not set to all"
        return
    endif

    let cur_start = getpos("'<")
    let cur_end   = getpos("'>")

    " Sanity checks. We've to consider the offset since 've' is set
    if    cur_start[1] == 0 ||
        \ cur_start[2] == 0 ||
        \ cur_end[1] == 0   ||
        \ cur_end[2] == 0
        echo "No visual selection made"
        return
    endif

    " Got to the first column
    normal `<
    let i = 0

    if a:direction ==? "l"
        for i in range(cur_start[1], cur_end[1])
            normal dwj
        endfor
    elseif a:direction ==? "r"
        let shift = input("Shift from start of line (y/n)? ", "n")
        if shift !=? "n" && shift !=? "y"
            echo "Invalid input"
            return
        elseif shift ==? "n"
            let move_cmd = input("Enter the command to select dragging point: ", "1B")
            if move_cmd !~? "^\\d*b$"
                let move_cmd = "B"
            endif
        endif

        " Save and later restore the marks
        let save_a = getpos("'a")
        let save_b = getpos("'b")
        let save_c = getpos("'c")

        for i in range(cur_start[1], cur_end[1])
            if shift ==? "n"
                execute "normal ma" . move_cmd . "mb$mclv`ar `bv`cd$p`aj"
            else
                normal ma^mb$mclv`ar `bv`cd$p`aj
            endif
        endfor

        call setpos("'a", save_a)
        call setpos("'b", save_b)
        call setpos("'c", save_c)
    endif
endfunction

" Function to insert a (possibly) unique time stamp. This can be used to refer to other locations in
" the code obviating the need for line-no. and similar references
function! InsertTimestamp(count) range
    let i = a:count
    let cursor_pos = getpos(".")

    if !executable("uuidgen") || !executable("awk")
        echo "Couldn't find necessary executables"
        return
    endif

    while i > 0
        " This will insert the timestamp onto a new line; hence we've to join lines
        execute "r !uuidgen | awk -F- '{printf $NF}'"

        let i -= 1
    endwhile

    if a:count == 1
        " Only one to insert; and let it remain inline ;)
        normal diw"_dd
        call setpos(".", cursor_pos)
        normal gP
    else
        " We just inserted the last timestamp; now move to where we were
        call setpos(".", cursor_pos)
    endif
endfunction

" To generage patch for SVN. This is used in SVNBaseDiff The --binary option
" was added for DOS files.  Patch ignores and strips the ^M's in diff output
" from DOS files and hence such patches would fail. The manual says this
" options wouldn't have any effect in POSIX comliant systems and hence is
" harmless when use in other situations
function MyPatch()
    call system("patch --binary -Ro " . escape(v:fname_out, ' \') . " " . escape(v:fname_in, ' \') . " < " .  escape(v:fname_diff, ' \'))
endfunction

" Function to make the tab line. Most of this is picked from the sample
" given in the doc. Changes that I made different from the default
" behavior are:
" * Tab page has the tab numbers instead of the no. of widows open
" * Tab title only shows the base name of the file, and this would
"   save space, and is more readable
function MakeTabLine()
    let tab_line = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let tab_line .= '%#TabLineSel#'
        else
            let tab_line .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let tab_line .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let tab_line .= GetTabFileName(i + 1) " 9ea3b718f344
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let tab_line .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let tab_line .= '%=%#TabLine#%999Xclose'
    endif

    return tab_line
endfunction

" Function which creates a title strength for a single tab page. This is invoked
" by MakeTabLine() (See: 9ea3b718f344) and used in setting GUI tab label
" (See: 7d0ec10437cd)
function GetTabFileName(n)
    " List of buffers in the tab
    let buf_list = tabpagebuflist(a:n)
    " The active window in the tab
    let win_in_tab = tabpagewinnr(a:n)
    " Buffer number contained in the active window
    let buffer_number = buf_list[win_in_tab - 1]
    if g:J_TablineFullPath
        " Get full path of the file loaded in the buffer
        let buffer_name = substitute(substitute(fnamemodify(bufname(buffer_number), ":."), '/$', '', ''), '/\(/*.\)[^/]\+/\@=', '/\1', 'g')
    else
        " Get the basename of name of the file loaded in the buffer
        let buffer_name = fnamemodify(substitute(bufname(buffer_number), '/$', '', ''), ":t")
    endif

    " Start with the tab number
    let prefix = " [" . a:n . "] "

    if getbufvar(buffer_number, "&modified") == 1
        let prefix .= "+ "
    endif

    return prefix . buffer_name . " "
endfunction

function ToggleTabline()
    let g:J_TablineFullPath = g:J_TablineFullPath ? 0: 1
endfunction

" ****************************************************
" ***************** END FUNCTIONS ********************
" ****************************************************

" for the diff mode
if &diff
    call GetNPNavigatonChoiceFromUser("d")
    cmap q qa
endif

" All set; now search and source the local file and source.
" it This file is supposed to contain the system-dependent settings for VIM
if filereadable($HOME . "/.vimrc.local")
    exe "source " . escape($HOME, ' \') . "/.vimrc.local"
endif
