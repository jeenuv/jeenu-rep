################################
# Jeenu's Personalized .bashrc #
################################

# Source global definitions if it exists
[ -f /etc/bashrc ] && . /etc/bashrc

###########################
####   Shell Aliases   ####
###########################
alias cd..='cd ..'
alias j='jobs -l'
alias h='history'
alias la='ls -a'
alias ll='ls --color=tty -l'
alias ls='ls --color=tty'
alias vimdiff='env -u DISPLAY vimdiff "+normal gg"'
alias vi='env -u DISPLAY vim -n'
alias grep='grep --color'
alias dirs='dirs -v'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias L='less -i'
alias V='env -u DISPLAY vim -nR -'
alias T='tail'
alias H='head'
alias G='grep'

# This is supposed to be used after a '|' from shell
alias Q="grep -v .svn/ > ~/tmp/errors && env -u DISPLAY vim -q ~/tmp/errors"

###########################
####  Shell Variables  ####
###########################
# Prompt strings
export PS1='\e[22;31m\H\e[00m [\e[22;32m\w\e[00m]\n\! $ '
export PS3='> '

# Seems like this is not needed as this is done from .bash_profile
# echo $PATH | grep $HOME/bin >/dev/null || export PATH=~/bin:$PATH

export EDITOR='env -u DISPLAY vim'
export SVN_EDITOR='env -u DISPLAY vim "+set tw=100"'

# Make the shell ignore the .svn when completing file/directory names
export FIGNORE=".svn:.o:~"

###########################
#### Utility Functions ####
###########################
# Function to launch a gui application in the background, with streams redirected to null
function launch()
{
    if [ "$#" -eq 0 ]; then
        echo launch: no arguments
        return
    fi

    # Now we've to interate over arguments and wrap them in quotes, as they
    # might have spaces or other characters in them!
    ARG_LIST=
    until [ -z "$*" ]; do
        NEXT_ARG=$(echo "$1" | sed "s/\\([](){}<>\$ '\";,*#&[]\\)/\\\\\\1/g")
        ARG_LIST="$ARG_LIST $NEXT_ARG"
        shift
    done

    eval "$ARG_LIST &>/dev/null &"
}

# Function to go up in the directory; level is specified as argument
function up()
{
    local dir=
    local i

    if [ -z "$1" ]; then
        cd ..
        ls
        return
    fi
    eval "for i in {1..$1}; do dir=\"\$dir../\"; done"
    cd $dir
    ls
}

# Function to re-make vimproj tags
function makevimprojtags()
{
    if [ "$#" -ne 1 ]; then
        echo "makevimprojtags: usage: makevimprojtags project_name"
        return
    fi

    if [ ! -d "$HOME/vimproj/$1" ]; then
        echo "makevimprojtags: vimproject \"$1\" doesn't exist"
        return
    fi

    if [ ! -f "$HOME/vimproj/$1/maketags" ]; then
        echo  "makevimprojtags: $HOME/vimproj/$1/maketags doesn't exist"
        return
    else
        $HOME/vimproj/$1/maketags $1
    fi
}

############################
### Completion functions ###
############################
function _vimproj_complete()
{
    local COMMANDS CUR
    local projects

    COMPREPLY=()
    CUR=${COMP_WORDS[$COMP_CWORD]}

    if [ "$COMP_CWORD" -eq 1 ]; then
        # Only directories and get rid of the '.' entry
        projects=$(find ~/vimproj -type d -printf "%f\n" | sed '1d')
        COMPREPLY=($(compgen -W "$projects" $CUR))
    fi
}

function _launch_complete()
{
    local COMMANDS CUR

    COMPREPLY=()
    CUR=${COMP_WORDS[COMP_CWORD]}

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=($(compgen -c $CUR))
    fi
}

############################
###   Shell Completion   ###
############################
complete -F _vimproj_complete -o default vimproj
complete -F _vimproj_complete -o default gvimproj
complete -F _vimproj_complete makevimprojtags

complete -c which
complete -c man
complete -c launch

complete -F _launch_complete -o default launch
complete -F _launch_complete -o default sudo

# Bookmarking features
[ -f "$HOME/.mybashutils" ] && source "$HOME/.mybashutils"
# read all bookmarks
bmprofile "$HOME/.book"

# Get SVN utilities
[ -f "$HOME/.mysvnutils" ] && source "$HOME/.mysvnutils"

# Set colors for 'ls'
[ "$TERM" != "dump" ] && eval "$(dircolors -b)"

# Source system dependent file if any.
# This, preferably, should be the last line in this file
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"