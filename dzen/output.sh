#!/bin/bash

now_playing=$(mpc current)
paused_state=$(mpc | grep paused | cut -d" " -f1)

DATE_COLOR="#4f8788"
CPU_COLOR="#58afb3"
RAM_COLOR="#b39775"
TEXT_COLOR="#f8f8f2"
BAT_COLOR=$RAM_COLOR
NP_COLOR=$CPU_COLOR

WORKSPACE_HL_COLOR="#66d9ef"

SCREEN_WIDTH=$(sres -W)
PADDING=$(printf '%0.1s' " "{1..2000})

# Getting the number of columns for padding calculations
num_columns=$(( ( (${SCREEN_WIDTH} / 5) - ( (${SCREEN_WIDTH} / 5)%2) ) / 2 ))

# Testing colors

bat_string_path="~/dotfiles/dzen"

cal_command="cal | dzen2 -l 6 -w 114 -p -fg \\${TEXT_COLOR} -bg \\${DATE_COLOR} -e 'onstart=uncollapse;button1=exit:0' -ta l -fn 'Meslo LG M DZ for Powerline':pixelsize=9 -y 20 -x 0"

while read -r line ; do
    case $line in
    W*)
        # bspwm internal state
        wm_raw=${line#??}
        wm_output=" "
        wm_dzen=" "
        IFS=":"
        set -- ${line}
        shift
        while [ $# -gt 0 ] ; do
            item=$1
            case $item in
                [OoFfUu]*)
                    case $item in
                        O*)
                            wm_output="$wm_output ◼ "
                            wm_dzen="$wm_dzen ^fg(${WORKSPACE_HL_COLOR})^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◼^ca()^ca()^fg() "
                            ;;
                        o*)
                            wm_output="$wm_output ◼ "
                            wm_dzen="$wm_dzen ^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◼^ca()^ca() "
                            ;;
                        F*)
                            wm_output="$wm_output ◻ "
                            wm_dzen="$wm_dzen ^fg(${WORKSPACE_HL_COLOR})^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◻^ca()^ca()^fg() "
                            ;;
                        f*)
                            wm_output="$wm_output ◻ "
                            wm_dzen="$wm_dzen ^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◻^ca()^ca() "
                            ;;
                    esac
                    ;;
                [L]*)
                    case ${item#?} in
                        t*)
                            tile_type="❖"
                            ;;
                        m*)
                            tile_type="♦"
                            ;;
                    esac
                    wm_output="$wm_output ${tile_type}"
                    wm_dzen="$wm_dzen ${tile_type}"
                    ;;
            esac
            shift
        done
        IFS=" "
        ;;
    Q*)
        # date string
        date_string=${line#?}
        ;;
    R*)
        ram_string=${line#?}
        ;;
    [FCD]*)
        bat_string=${line}
        case $bat_string in
            C*)
                bat_icon="^i(${bat_string_path}/ac.xbm)"
                ;;
            D*)
                bat_icon="^i(${bat_string_path}/bat_full_01.xbm)"
                ;;
            F*)
                bat_icon="^i(${bat_string_path}/charging.xbm)"
                ;;
        esac
        ;;
    U*)
        cpu_string=${line#?}
        ;;
    V*)
        current_volume="(${line#?})"
        ;;
    p*)
        now_playing=$(mpc current)
        paused_state=$(mpc | grep paused | cut -d" " -f1)
    esac


    # Enhanced output with padding
    # For reference, the way this bit of crap works and why it's about the best thing
    # I can think of for the time being:
    #
    # string1 and string2 are nothing more than placeholders. They are meant to expand
    # into strings tht have the exact same length as the visible text that comes out of
    # dzen. i.e., the text without all the formatting sequences dzen uses.
    # the borderstrings are formatting sequences to shuffle the colors around properly
    # to make the transitions between sections look good.
    #
    # The real magic is in the lines that create the padding. Unfortunately, everything
    # is typeface-specific, so $MAGIC_DIVISION_NUMBER will need to be changed if you use
    # another typeface apart from Meslo at pixelsize 9. 
    # 
    # Nevertheless, the way it works is by truncating a pre-generated massive string of " "
    # characters dynamically to ( $NUM_COLUMNS_OF_LETTERS - ${LENGTH_OF_STRING_1} - ( ${LENGTH_OF_WORKSPACE_STRING} / 2 )
    # on the left side, and( $NUM_COLUMNS_OF_LETTERS - ${LENGTH_OF_STRING_2} - ( ${LENGTH_OF_WORKSPACE_STRING} / 2 ) on
    # the right. So, the order of the strings ends up being string1-spaces-workspaces-spaces-string2. 
    # This keeps the workspace string exactly at the center of the screen at all times. hooray padding!
    #
    # But seriously, this took ages to figure out, I hope you use this forever.
    string1=" ${date_string}  cpu: ${cpu_string}  ram: ${ram_string} "
    string2=" i ${bat_string}  ${current_volume} ♫ ${paused_state} ${now_playing} "
    borderstring1="^bg(${DATE_COLOR})"
    borderstring2="^fg(${DATE_COLOR})^bg(${CPU_COLOR})"
    borderstring3="^fg()"
    borderstring4="^fg(${CPU_COLOR})^bg(${RAM_COLOR})"
    borderstring5="^fg(${RAM_COLOR})^bg()"
    borderstring6="^fg()^bg()"
    borderstring7="^fg(${BAT_COLOR})^bg()"
    borderstring8="^fg()^bg(${BAT_COLOR})"
    borderstring9="^fg(${NP_COLOR})"
    borderstring10="^fg()^bg(${NP_COLOR})"

    printf '%s' "$borderstring1"
    printf '%s' "^ca(1, ${cal_command}) ${date_string} ^ca()"
    printf '%s' "$borderstring2"
    printf '%s' ""
    printf '%s' "$borderstring3"
    printf '%s' "^ca(1, systemctl suspend)^ca(3, systemctl poweroff)^ca(2, systemctl reboot) cpu: ${cpu_string} ^ca()^ca()^ca()"
    printf '%s' "$borderstring4"
    printf '%s' ""
    printf '%s' "$borderstring3"
    printf '%s' " ram: ${ram_string} "
    printf '%s' "${borderstring5}"
    printf '%s' ""
    printf '%s' "${borderstring6}"

    printf '%*.*s' 0 $(( ${num_columns} - ${#string1} - $(( ${#wm_output} /2 )) )) "$PADDING"
    printf "%s" "${wm_dzen}"
    printf '%*.*s' 0 $(( ${num_columns} - $(( ${#wm_output} / 2 )) - ${#string2} )) "$PADDING"

    printf '%s' "$borderstring7"
    printf "%s" ""
    printf '%s' "$borderstring8"
    printf "%s" " ${bat_icon} ${bat_string} "
    printf '%s' "$borderstring9"
    printf '%s' ""
    printf '%s' "$borderstring10"
    printf '%s' " ^ca(1, ponymix toggle)${current_volume}^ca() ♫ ^ca(1, mpc toggle)${paused_state} ${now_playing}^ca() "
    printf '\n'

done
