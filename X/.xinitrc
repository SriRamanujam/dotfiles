#!/bin/sh

#
#~/.xinitrc
#
#Executed by startx
#

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#if [ $(xrandr -q | grep -c HDMI) -ne 0 ]
#then
#    xrandr --output LVDS --off
#	xrandr --output VGA-0 --mode 1680x1050 --output HDMI-0 --mode 1920x1080 --right-of VGA-0
#else
#	xrandr --output LVDS --mode 1366x768
#fi

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#exec pulseaudio --start
#xsetroot -cursor_name left_ptr
#exec xmonad

#exec openbox-session
#exec i3
exec startkde

#exec cinnamon-session
