#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h:\w]\$ '

# from this point on i'm pretty much going to be copying ubuntu lol

HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s checkwinsize

case "$TERM" in
	xterm-color) color_prompt=yes;;
esac

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

fehbg() {
	feh --bg-fill "$1"
	cp "$1" /home/sri/wallpaper
	echo "feh --bg-fill /home/sri/wallpaper" > ~/.fehbg	
}

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e'\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


