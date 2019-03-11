#
# ~/.bashrc
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;
esac

export GTK_RC_FILES=$HOME/.gtkrc-2.0
export EDITOR=nvim
export BROWSER=firefox-nightly
export PAGER="/usr/bin/most -s"
export SYSTEMD_PAGER="/usr/bin/less"
export GIT_PAGER="/usr/bin/most -s"


export TERM=xterm-256color

PATH="$HOME/.local/bin:$PATH"

# Set up ruby gems path
if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

# set PATH so it includes ~/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes Rust toolchain stuff
if [ -f "$HOME/.cargo/env" ] ; then
    source "$HOME/.cargo/env"
fi

# setup auto completion for fzf
[[ $- == *i* ]] && source "/home/sramanujam/Documents/fzf/shell/completion.bash" 2> /dev/null

# Copying variables from Ubuntu because they make life easier
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands in history
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Use standard ISO 8601 timestamp
HISTTIMEFORMAT="%F %T "
# append to the history file, don't overwrite it
shopt -s histappend
# Enable incemental history search with up/down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
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
# basic error completion when tabbing
shopt -s dirspell
# Perform file completion in a case-insensitive fashion
bind "set completion-ignore-case on"
# Display matches for ambiguous pattertns at first tab press
bind "set show-all-if-ambiguous on"


# set the PS1
if $(grep -q "Ubuntu" /etc/os-release); then
    source /etc/bash_completion.d/git-prompt
elif $(grep -qi -e "centos" -e "fedora" /etc/os-release); then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

# Git prompt control variables
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto name"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWCOLORHINTS=1
function get_sha {
    git rev-parse --short HEAD 2> /dev/null
}

function prompt {
    local last_command_status=$?
    PS1=""
    PS1+="\[\033[00;37m\]\u@\h " # set user and host
    PS1+="\[\033[00;34m\]\w " # set current location
    if [[ -n "$VIRTUAL_ENV"  ]]; then
        PS1+="\[\033[00;32m\]" # set virtualenv color
        PS1+="<$(echo $VIRTUAL_ENV | awk -F "/" '{print $(NF-1)}')> "
        PS1+="\[\033[00m\]" # reset color
    fi
    PS1+="\[\033[00;33m\]" # set git color
    PS1+='$(__git_ps1 "(%s $(get_sha))")' # call __git_ps1 to get git information
    if [[ $last_command_status == 0 ]]; then
        PS1+="\n\[\033[00;36m\]❯ " # set newline and prompt
    else
        PS1+="\n\[\033[00;31m\]❯ " # set newline and prompt
    fi
    PS1+="\[\033[00m\]" # reset color
}
PROMPT_COMMAND='prompt'

# Some user-defined exports and sources here
export WORKON_HOME=/home/sri/.venvs
export PROJECT_HOME=/home/sri/Documents/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
export VAGRANT_DEFAULT_PROVIDER=libvirt
export MOZ_USE_XINPUT2=1
#source /usr/bin/virtualenvwrapper.sh

# Set up colors
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ls='ls --color=auto'
alias ll='ls -alFhksZ --color=auto --group-directories-first'

alias df='df -Tha --total'
alias free='free -mt'
alias vim='nvim'

# Need to figure out a good diff alias. 
alias diff='diff -u'

# I do this a lot
alias mimetype='file --mime-type'

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

buildscripts() {
    time ./build.sh "$@" | tee build-results.txt
}
alias buildit=buildscripts
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e'\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias livestreamer='livestreamer --player=/usr/bin/mpv'
alias containerboot='sudo systemd-nspawn -bD'
alias dathomirdev='ssh 192.168.39.2'

# Fucking java
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

shasums() {
    for x in sha1sum sha256sum md5sum; do
        $x $1
    done
    ls -l $1
}

PATH="/home/sri/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/sri/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sri/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sri/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sri/perl5"; export PERL_MM_OPT;
#source ~/bin/nvm/nvm.sh

oscbuild() {
    osc build --root=$(realpath ./buildroot) --clean xUbuntu_18.04 x86_64 --local-package
}

new-tmux() {
    tmux new -s $(basename $PWD)
}

# now for tmux shenanigans
tmux-attach() {
    if $(tmux list-sessions &>/dev/null); then
        tmux attach -t "$(tmux list-sessions | fzf | cut -d':' -f1)"
    else
        tmux new
    fi
}

cleanup-docker() {
    docker volume rm $(docker volume ls -qf dangling=true)
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
}
