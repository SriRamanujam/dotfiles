#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GTK_RC_FILES=$HOME/.gtkrc-2.0

# set PATH so it includes ~/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

alias ls='ls --color=auto'
PS1='[\u@\h:\w]\$ '

# Some user-defined exports and sources here
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk/lib
export WORKON_HOME=/home/sri/.venvs
export PROJECT_HOME=/home/sri/Documents/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
source /usr/bin/virtualenvwrapper.sh

case "$TERM" in
    xterm-color) color_prompt=yes;;
    rvxt-unicode-256color) color_prompt=yes;;
esac

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alFhk --group-directories-first'
alias la='ls -A'
alias l='ls -CF'

# Need to figure out a good diff alias. 
# alias diff='diff -ys --suppress-common-lines'

# I'll figure this out properly later
alias ssh='TERM=xterm ssh'

alias feh='feh --scale-down'
fehbg() {
    feh --bg-fill "$1"
    cp "$1" /usr/share/backgrounds/wallpaper 2>/dev/null
    convert -adaptive-resize 1920x1080 "$1"  /usr/share/backgrounds/wallpaper.png
    convert /usr/share/backgrounds/wallpaper -blur 0x7 /usr/share/backgrounds/login.jpg
    echo "feh --bg-fill /usr/share/backgrounds/wallpaper" > ~/.fehbg
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e'\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

