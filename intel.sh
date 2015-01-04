#!/bin/sh

# God knows if this will work. This is very theoretical code at this point.

lspci | grep VGA | grep Intel &> /dev/null
status=$?
if [[ $status -ne 0 ]]; then
    if [[ -e "/etc/X11/xorg.conf.d/20-intel.conf" ]]; then
        echo "Discrete card detected; removing 20-intel.conf from xorg.conf.d"
        rm "/etc/X11/xorg.conf.d/20-intel.conf"
    else
        echo "Nothing to do; exiting cleanly"
        exit
    fi
else
    if [[ -e "/etc/X11/xorg.conf.d/20-intel.conf" ]]; then
        echo "Nothing to do; exiting cleanly"
        exit
    else
        echo "Integrated card present; moving 20-intel.conf into xorg.conf.d"
        cp "/home/sri/dotfiles/20-intel.conf" "/etc/X11/xorg.conf.d/20-intel.conf"
    fi
fi
