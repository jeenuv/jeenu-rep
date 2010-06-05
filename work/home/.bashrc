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
alias lr='ls --color=tty -1rt'
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
# Colorize diff output
alias D="sed 's/^\(Index\|---\|+++\).*/[1;32m&[0m/;s/^-.*/[1;35m&[0m/;s/^+.*/[1;36m&[0m/;s/^@@.*/[1;33m&[0m/' | L"

# This is supposed to be used after a '|' from shell
alias G='grep -nHI --exclude=\*.svn-base'
alias Q='grep -v .svn/ > ~/tmp/errors && env -u DISPLAY vim "+SetNavChoice c" "+cfile ~/tmp/errors"'

###########################
####  Shell Variables  ####
###########################
# Prompt strings
export PS1='\e[22;31m\H\e[00m [\e[22;32m\w\e[00m]\n\! $ '
export PS3='> '

# Even if this is done from bash_profile, it's safe to have it here
echo $PATH | grep "^$HOME/bin" >/dev/null || export PATH=~/bin:$PATH

export EDITOR='env -u DISPLAY vim'
export SVN_EDITOR='env -u DISPLAY vim "+set tw=100"'

# Make the shell ignore the .svn when completing file/directory names
FIGNORE=".svn:.git:.o:~"

# Set history size to a larger value
HISTSIZE=1000

# Histroy control
HISTCONTROL=ignorespace:ignoredups:erasedups

# Processing for setting up less
if [ -z "$LESSOPEN" ]; then
    # Cygwin might have lesspipe.sh
    less_proc_path="$(which lesspipe 2>/dev/null)" || less_proc_path="$(which lesspipe.sh 2>/dev/null)"
    [ -z "$less_proc_path" ] || eval "$("$less_proc_path")"
    unset less_proc_path
fi

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

# Wrapper function to capture rm -rf commands
function rm()
{
    local actual_rm="$(which rm)"
    local must="rm: Thou shalt invoke $actual_rm directly"
    local recursive=0

    if ! which getopt >/dev/null; then
        echo "rm: This function requires GNU getopt in \$PATH"
        echo "$must"
        return 1
    fi

    if ! which uuidgen >/dev/null; then
        echo "rm: This function requires uuidgen utility in \$PATH"
        echo "$must"
        return 1
    fi

    if [ -z "$*" ]; then
        command rm "$@"
        return
    fi

    local saved_args=("$@")
    eval set -- $(getopt -o "rR" -l 'recursive' -q -- "$@")

    if [ "$?" -ne 0 -a "$?" -ne 1 ]; then
        echo "rm: 'getopt' returned error"
        echo "$must"
        return 1
    fi

    until [ -z "$*" ]; do
        case "$1" in
            -r | -R | --recursive)
            recursive=1
            ;;

            --)
            shift
            local arguments="$@"
            break
            ;;
        esac

        shift
    done

    set -- "${saved_args[@]}"

    # Check if the user specified a -r
    if [ "$recursive" -eq 1 ]; then
        local mark="$(uuidgen | awk -F- '{print toupper($2)}')"
        echo "rm: To proceed, enter the following text below: $mark"
        echo -n "** $arguments **: "
        read
        if [ "$REPLY" != "$mark" ]; then
            echo "rm: Command aborted"
            echo "$must"
            return 1
        else
            command rm "$@"
        fi
    else
        command rm "$@"
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

# Get all available BASH completion
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# My own SVN utilities
[ -f "$HOME/.mysvnutils" ] && source "$HOME/.mysvnutils"

# My own GIT utilities
[ -f "$HOME/.mygitutils" ] && source "$HOME/.mygitutils"

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
