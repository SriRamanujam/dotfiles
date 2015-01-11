#!/usr/bin/env bash

if [[ $(xrandr -q | grep "HDMI1 connected") ]]
then
    $(xrandr --output HDMI1 --auto --output eDP1 --off)
else
    $(xrandr --output eDP1 --auto --output HDMI1 --off)
fi
