# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white


# parse the branch name you are currently on based on 'git branch' output
function parse_git_branch () {
	#redirect errors to /dev/null then parse branch name
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# checks if branch has pending changes
function parse_git_dirty() {
    git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo "*"
}

# get last commit hash
function parse_git_hash() {
  git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/"
}




#### PS1 breakdown ####
# '$HC': hicolor, brighten up the text
# '$FBLE': set foreground to blue
# '['
# '$FWHT': set foreground to white
# '\A': timestamp HH:MM
# '$FRED': set foreground to red
# '${debian_chroot:+($debian_chroot)}': tell me if i'm in da chroot
# '\u': display current username
# '$FBLE': set foreground to blue
# ':'
# '$FYEL': set foreground to yellow
# '\w': display current working directory
# '$FWHT': change foreground to white
# '\': call parse_git_branch everytime
# '$(parse_git_branch)': if you are in a git repo, get the name of current branch
# '\': call parse_git_hash everytime
# 'parse_git_hash' if you are in a git repo, get the current commit hash
# '$FRED': change foreground to red for indicating dirty git things
# 'parse_git_dirty': put an asterick up if files have changed since last commit
# '$FBLE': change the foreground to blue
# ']'
# '$FGRN': green plz







if [ "$color_prompt" = yes ]; then
    #PS1="$FGRN[kevin]\w$"
    PS1="$HC$FBLE[$FMAG\A $RS$FRED${debian_chroot:+($debian_chroot)}\u@\H$HC$FBLE: $FCYN\w $FCYN($FYEL\$(parse_git_branch)$FCYN-$FYEL\$(parse_git_hash)$FRED\$(parse_git_dirty)$FCYN)$FBLE]$ $FGRN"
    PS2=">"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS2=">"
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

PATH_TO_DEV='/home/kevin/Git/'
FEMR='femr'
BLISST='android-task-manager'
CFOUND='cf-release'


alias femr='cd $PATH_TO_DEV$FEMR'
alias blisst='cd $PATH_TO_DEV$BLISST'
alias cfound='cd $PATH_TO_DEV$CFOUND'
alias gl='git log --pretty="format:%H %aN %s %G?" -n 5'

# some more ls aliases
alias l='ls -alF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
