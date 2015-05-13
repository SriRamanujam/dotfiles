#!/bin/bash

PANEL_FIFO=/tmp/panel-fifo-2
PANEL_HEIGHT=22
WORKING_DIR=$(dirname "$(readlink -f "$0")")
echo $WORKING_DIR

if [ $(pgrep -cx panel) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

bspc config top_padding $PANEL_HEIGHT

# We begin piping things to the named pipe here.

# Next, date(1) is piped into the fifo.
while true; do
    date_var=$(date +"%I:%M%P %D") && date_var="Q${date_var}"
    if [[ $date_var == $date_var_old ]]
    then
        sleep 1
    else
        echo $date_var && date_var_old=${date_var} && sleep 1
    fi
done > "$PANEL_FIFO" &

# RAM output, formatted in human-readable units using free(1)
#while true; do ram_var=$(free -h) && echo "R$(echo $ram_var | awk '{print $16}') / $(echo $ram_var | awk '{print $8}')" && sleep 1; done > "$PANEL_FIFO" &

# ACPI battery output using UPower and Python
python ${WORKING_DIR}/upower.py &> "$PANEL_FIFO" &

# CPU using mpstat(1)
#while true; do echo $(mpstat 2 1 | awk '$3 ~ /CPU/ { for(i=1;i<=NF;i++) { if ($i ~ /%idle/) field=i } } $3 ~ /all/ { printf"U%s%", 100 - $field}'); done > "$PANEL_FIFO" &

# Volume using ponymix
while true; do
    curvol=$(ponymix 2>/dev/null | grep "Avg" | awk '{print $3, $4}' | head -1)
    curvol="V${curvol}"
    if [[ $curvol == $curvol_old  ]]
    then
        /usr/bin/sleep 0.5s
    else
        echo $curvol && curvol_old=${curvol} && /usr/bin/sleep 0.5s
    fi
done > "$PANEL_FIFO" &

# network monitor using dstat
# dstat -n --nocolor --noheaders | awk '{print " NDown: " $1 " Up: " $2}' > "$PANEL_FIFO" &

# network monitor using the power of python and Dbus
python ${WORKING_DIR}/nm.py &> "$PANEL_FIFO" &

# Python script
#python producer1.py >"$PANEL_FIFO" &

# sends mpd status changes into the fifo
mpc idleloop player playlist > "$PANEL_FIFO" &

bspc control --subscribe > "$PANEL_FIFO" &

/usr/bin/sleep 0.5s

#cat "$PANEL_FIFO" | $HOME/dotfiles/panel/output.sh
cat "$PANEL_FIFO" | $HOME/dotfiles/panel/output.sh | dzen2 -p -fn "Meslo LG M DZ for Powerline":pixelsize=9 -bg "#262626" -h $PANEL_HEIGHT -fg "#f8f8f2" -e '' &

wait
