#!/bin/bash

now_playing=$(mpc current)
paused_state=$(mpc | grep paused | cut -d" " -f1)

DATE_COLOR="#4f8788"
CPU_COLOR="#58afb3"
RAM_COLOR="#b39775"
TEXT_COLOR="#f8f8f2"
NOTE_COLOR="#f92672"
BAT_DISCHARGE_COLOR=$RAM_COLOR
BAT_CHARGE_COLOR=$CPU_COLOR
BAT_FULL_COLOR="#9d5"
NP_COLOR=$CPU_COLOR


WORKSPACE_HL_COLOR="#66d9ef"
WORKSPACE_URGENT_FOCUSED_COLOR="#ff2029"
WORKSPACE_URGENT_COLOR="#ff5362"
SIGNAL_GOOD_COLOR="#9d5"
SIGNAL_MEDIUM_COLOR="#ffe1a0"
SIGNAL_BAD_COLOR=$WORKSPACE_URGENT_FOCUSED_COLOR
LINK_NAME="wlp2s0"

SCREEN_WIDTH=$(sres -W)
PADDING=$(printf '%0.1s' " "{1..3000})

# Getting the number of columns for padding calculations
num_columns=$(( ( (${SCREEN_WIDTH} / 5) - ( (${SCREEN_WIDTH} / 5)%2) ) / 2 ))

cal_command="cal | dzen2 -l 6 -w 114 -p -fg \\${TEXT_COLOR} -bg \#262626 -e 'onstart=uncollapse;button1=exit:0' -ta l -fn 'Meslo LG M DZ for Powerline':pixelsize=9 -y 22 -x 0"
wifi_command="iw dev ${LINK_NAME} link | tr -d '\t' | dzen2 -l 11 -w 250 -fg \\${TEXT_COLOR} -bg \#262626 -e 'onstart=uncollapse;button1=exit:0' -ta l -fn 'Meslo LG M DZ for Powerline':pixelsize=9 -y 22 -p"

while read -r line ; do
    ACPI_COMMAND_OFFSET=$(( $(sres -W) -  $(( ${#string2} * 5)) - $(( ${#string2} * 1 )) ))
    acpi_command="acpi -b | dzen2 -w 239 -p -fg \\${TEXT_COLOR} -bg \#262626 -e 'onstart=uncollapse;button1=exit:0' -ta c -fn 'Meslo LG M DZ for Powerline':pixelsize=9 -y 22 -x ${ACPI_COMMAND_OFFSET}"
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
                        U*)
                            wm_output="$wm_output ◼ "
                            wm_dzen="$wm_dzen ^fg(${WORKSPACE_URGENT_FOCUSED_COLOR})^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◼^ca()^ca()^fg() "
                            ;;
                        u*)
                            wm_output="$wm_output ◼ "
                            wm_dzen="$wm_dzen ^fg(${WORKSPACE_URGENT_COLOR})^ca(1, bspc desktop -f ${item#?})^ca(2, bspc window -d ${item#?})◼^ca()^ca()^fg() "
                            ;;
                    esac
                    ;;
                [L]*)
                    case ${item#?} in
                        T*)
                            tile_type=" "
                            ;;
                        M*)
                            tile_type="⧫"
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
        percent=$(echo $bat_string | awk -F ',' '{print $2}' | sed -e 's/^[ \t]*//' -e 's/[ \t]*$//' -e 's/%//')
        total_blocks_num=$(( $percent / 10 ))
        full_batt_bars=$(printf '%0.1s' "|"{1..10})
        case $bat_string in
            C*)
                stars="^fg(${BAT_CHARGE_COLOR})"
                stars=${stars}$(printf '%*.*s' 0 $total_blocks_num "$full_batt_bars")
                stars=${stars}"^fg()"
                stars=${stars}$(printf '%*.*s' 0 $(( 10 - $total_blocks_num )) "$full_batt_bars" )
                ;;
            D*)
                stars="^fg(${BAT_DISCHARGE_COLOR})"
                stars=${stars}$(printf '%*.*s' 0 $total_blocks_num "$full_batt_bars")
                stars=${stars}"^fg()"
                stars=${stars}$(printf '%*.*s' 0 $(( 10 - $total_blocks_num )) "$full_batt_bars" )
                ;;
            F*)
                stars="^fg(${BAT_FULL_COLOR})||||||||||^fg()"
                ;;
        esac
        stars="^ca(1,${acpi_command})"${stars}"^ca()"
        ;;
    U*)
        cpu_string=${line#?}
        ;;
    N*)
        net_input_string=${line#?}
        case $net_input_string in
            S*)
                signal_strength=$(echo $net_input_string | awk -F ': ' '{print $2}')
                if [[ $signal_strength -gt 68 ]]; then
                    net_color=$SIGNAL_GOOD_COLOR
                elif [[ $signal_strength -gt 40 ]]; then
                    net_color=$SIGNAL_MEDIUM_COLOR
                elif [[ $signal_strength -gt 0 ]]; then
                    net_color=$SIGNAL_BAD_COLOR
                fi
                ;;
            A*)
                ssid_string=$(echo $net_input_string | awk -F ': ' '{print $2}')
                ;;
        esac
        net_colored_string="^ca(1, ${wifi_command})^fg(${net_color})"${ssid_string}"^fg()^ca()"
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
    string1=" ${date_string} ${ssid_string} "
    string2=" |||||||||| ${current_volume} ♫ ${paused_state} ${now_playing} "
    borderstring1=""
    borderstring2=""
    borderstring3=""
    borderstring4=""
    borderstring5=""
    borderstring6=""
    borderstring7=""
    borderstring8=""
    borderstring9=""
    borderstring10=""
    borderstring11=""
    borderstring12=""

    printf '%s' "$borderstring1"
    printf '%s' "^ca(1, ${cal_command}) ${date_string} ^ca()"
    printf '%s' "$borderstring2"
    printf '%s' ""
    printf '%s' "$borderstring3"
#    printf '%s' "^ca(1, systemctl suspend)^ca(3, systemctl poweroff)^ca(2, systemctl reboot) cpu: ${cpu_string} ^ca()^ca()^ca()"
    printf '%s' "$borderstring4"
    printf '%s' ""
    printf '%s' "$borderstring5"
    printf '%s' " ${net_colored_string} "
    printf '%s' ""
    printf '%s' "${borderstring6}"

    printf '%*.*s' 0 $(( ${num_columns} - ${#string1} - $(( ${#wm_output} /2 )) )) "$PADDING"
    printf "%s" "^p(;-1)${wm_dzen}^p()"
    printf '%*.*s' 0 $(( ${num_columns} - $(( ${#wm_output} / 2 )) - ${#string2} )) "$PADDING"

    printf '%s' "$borderstring7"
    printf "%s" ""
    printf '%s' "$borderstring8"
    printf "%s" " ^p(;-1)${stars}^p()"
    printf '%s' " $borderstring9"
    printf '%s' ""
    printf '%s' "$borderstring10"
    printf '%s' "^ca(1, ponymix toggle)${current_volume}^ca() ^fg(${NOTE_COLOR})♫^fg()^ca(1, mpc toggle)${paused_state} ${now_playing}^ca() "
    printf '\n'

done
