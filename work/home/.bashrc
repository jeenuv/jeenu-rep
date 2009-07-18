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
alias bell='echo -ne "\a"'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias L='less -iRSw'
alias V='env -u DISPLAY vim -nR -'
alias T='tail'
alias H='head'
alias G='grep'
# Colorize diff output
alias D="sed 's/^\(Index\|---\|+++\).*/[1;32m&[0m/;s/^-.*/[1;35m&[0m/;s/^+.*/[1;36m&[0m/;s/^@@.*/[1;33m&[0m/' | L"

# This is supposed to be used after a '|' from shell
alias Q="GREP_OPTIONS= grep -v .svn/ > ~/tmp/errors && env -u DISPLAY vim -q ~/tmp/errors"
alias VP="GREP_OPTIONS= grep -v .svn/ > ~/tmp/errors && env -u DISPLAY vimproj -q ~/tmp/errors"

###########################
####  Shell Variables  ####
###########################
# Prompt strings
export PS1='\e[22;31m\H\e[00m [\e[22;32m\w\e[00m]\n\! $ '
export PS3='> '

# Even if this is done from bash_profile, it's safe to have it here
echo $PATH | grep "$HOME/bin" >/dev/null || export PATH=~/bin:$PATH

export EDITOR='env -u DISPLAY vim'
export SVN_EDITOR='env -u DISPLAY vim "+set tw=100"'

# Make the shell ignore the .svn when completing file/directory names
FIGNORE=".svn:.git:.o:~"

# Set history size to a larger value
HISTSIZE=1000

# Histroy control
HISTCONTROL=ignorespace:ignoredups:erasedups
HISTIGNORE='mplayer*'

# Some commonly used Grep options
export GREP_OPTIONS='-nHI --exclude=\*.svn-base'

# Create a tmp directory
if [ ! -d ~/tmp ]; then
    mkdir ~/tmp
fi

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

# Funtion to ask y/n questions
function confirm()
{
    if [ -z "$*" ]; then
        return 1
    fi

    echo -n "${PROGNAME+$PROGNAME: }$1 (y/n) "
    read
    if [ "$REPLY" = "y" -o "$REPLY" = "Y" ]; then
        return 0
    else
        return 1
    fi
}
export -f confirm

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

# Function to play all media files in a directory. More file types can be added later
function playall()
{
    {
        find \( -iname \*avi -o -iname \*mp\*g -o -iname \*wmv -o -iname \*dat \) -print0 | \
        xargs -0 sh -c 'exec mplayer "$@" <&3 3<&-' sh;
    } 3<&0
}

# Function to wait until a PID or an input pattern disappears from the list
# of processes. I.e. they are termiated. This would come in handy to queue another
# process, say, another download, only after the current one is finished.
#
# The command to get the list of processes is first obtained from $PS_COMMAND, if set.
# This is particularly useful in Cygwin, where -W, a non standard option, is needed to
# view Windows processes
#
# If there's a second argument, that's assumed as a command to be executed after woke
# up from sleep
function waitfor()
{
    local pat
    local ps_command="${PS_COMMAND:-ps aux}"
    local usage="Usage: waitfor [-w <until>] [-t <wait>] [-c <command>] identifier"
    local wait_until=0
    local wait_time=5
    local wait_command=

    if [ -z "$*" ]; then
        echo "$usage"
        return 1
    fi

    if ! which getopt >/dev/null; then
        echo "waitfor: This function requires GNU getopt in \$PATH"
        return 1
    fi

    eval set -- $(getopt -o "w:t:c:" -q -- "$@")

    if [ "$?" -ne 0 -a "$?" -ne 1 ]; then
        echo "waitfor: 'getopt' returned error"
        return 1
    fi

    until [ -z "$*" ]; do
        case "$1" in
            -w)
            shift
            wait_until="$1"
            ;;

            -t)
            shift
            wait_time="$1"
            ;;

            -c)
            shift
            wait_command="$1"
            ;;

            --)
            shift
            break
            ;;
        esac

        shift
    done

    if [ -z "$1" ]; then
        echo "$usage"
        return 1
    fi

    sleep "$wait_until"
    # Convert, say, wget to [w]get
    pat="$(echo "$1" | sed 's/./[&]/')"
    while $ps_command | grep -q "$pat"; do
        $wait_command
        sleep "$wait_time"
    done
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

    # We don't have anything to complete if directory itself isn't there!
    if [ ! -d ~/vimproj ]; then
        return
    fi

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

# Set colors for 'ls'
[ "$TERM" != "dump" ] && eval "$(dircolors -b)"

# I don't want alias expansions to happen when sourcing other utilities
if shopt expand_aliases &>/dev/null; then
    shopt -u expand_aliases
    shell_aliases_disabled=yes
fi

# Bookmarking features
[ -f "$HOME/.mybashutils" ] && source "$HOME/.mybashutils"
# read all bookmarks
bmprofile "$HOME/.book"

# Get SVN completion
if [ -f /etc/bash_completion.d/svn ]; then
    source /etc/bash_completion.d/svn
    svn_sourced=yes
fi

# My own SVN utilities
[ -f "$HOME/.mysvnutils" ] && source "$HOME/.mysvnutils"
unset svn_sourced

# Set colors for 'ls'
[ "$TERM" != "dump" ] && eval "$(dircolors -b)"

# Source system dependent file if any.
# This, preferably, should be the last line in this file
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

# Restore the shell aliasing setting
if [ "$shell_aliases_disabled" = "yes" ]; then
    shopt -s expand_aliases
    unset shell_aliases_disabled
fi
