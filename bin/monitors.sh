#!/usr/bin/env bash

xrandr_output=$(xrandr -q | grep "VGA1 connected")

if [[ $(xrandr -q | grep "VGA1 connected") ]]
then
    $(xrandr --output VGA1 --auto --output LVDS1 --off)
else
    $(xrandr --output LVDS1 --auto --output VGA1 --off)
fi
