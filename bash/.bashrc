#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GTK_RC_FILES=$HOME/.gtkrc-2.0
export EDITOR=vim
export BROWSER=firefox-nightly
export PAGER="/usr/bin/most -s"

# Source dircolors, because nothing ever works right out of the box
source $HOME/.dircolors

# Set up ruby gems path
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
# set PATH so it includes ~/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi



# Copying variables from Ubuntu because they make life easier
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# History file sizes
HISTSIZE=100000
HISTFILESIZE=100000
# check the window size after each command and update the value
# of LINES and COLUMNS if necessary
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories
shopt -s globstar
# extended pattern matching fun
shopt -s extglob
# include .dotfiles when globbing
shopt -s dotglob
# when a glob expands to nothing, make it an empty string instead of the literal
#shopt -s nullglob
# when you type a directory as a command, treat it like cd
shopt -s autocd
# basic error correction for cd
shopt -s cdspell
# Use lesspipe for some reason, mainly because ubuntu ships it
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set ls to make the pretty colors
alias ls='ls --color=auto'

# set the PS1
function prompt {
    local __user_and_host="\[\033[00;37m\]\u@\h"
    local __cur_location="\[\033[00;34m\]\w"
    local __git_color="\[\033[00;33m\]"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __newline_and_prompt="\n\[\033[00;36m\]❯ "
    local __color_reset="\[\033[00m\]"
    export PS1="$__user_and_host $__cur_location $__git_branch$__newline_and_prompt$__color_reset"
}
prompt

# Some user-defined exports and sources here
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk/
export WORKON_HOME=/home/sri/.venvs
export PROJECT_HOME=/home/sri/Documents/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
#source /usr/bin/virtualenvwrapper.sh

# Not strictly necessary, but here anyway
case "$TERM" in
    xterm-color) color_prompt=yes;;
    rvxt-unicode-256color) color_prompt=yes;;
    xterm-termite) color_prompt=yes;;
esac

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alFhk --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

alias df='df -Tha --total'
alias free='free -mt'

# Need to figure out a good diff alias. 
# alias diff='diff -ys --suppress-common-lines'

# This is so that I get bash completion with sudo
complete -cf sudo

# Things related to feh and wallpapering
alias feh='feh --scale-down'
fehbg() {
    feh --bg-fill "$1"
    cp "$1" /usr/share/backgrounds/wallpaper 2>/dev/null
    convert -adaptive-resize 1920x1080 "$1"  /usr/share/backgrounds/wallpaper.png
    convert /usr/share/backgrounds/wallpaper -blur 0x7 /usr/share/backgrounds/login.jpg
    echo "feh --bg-fill /usr/share/backgrounds/wallpaper" > ~/.fehbg
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e'\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias livestreamer='livestreamer --player=/usr/bin/mpv'

alias containerboot='sudo systemd-nspawn -bD'

# Fucking java
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' 


PATH="/home/sri/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/sri/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sri/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sri/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sri/perl5"; export PERL_MM_OPT;
