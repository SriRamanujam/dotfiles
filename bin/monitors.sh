#!/usr/bin/env bash

xrandr_output=$(xrandr -q | grep "HDMI-0 connected")

if [[ $(xrandr -q | grep "HDMI-0 connected") ]]
then
    $(xrandr --output LVDS --off --output HDMI-0 --auto)
else
    $(xrandr --output LVDS --auto --output HDMI-0 --off --output VGA-0 --off)
fi

