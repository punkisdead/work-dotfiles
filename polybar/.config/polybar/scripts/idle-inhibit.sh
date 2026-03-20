#!/bin/bash

STATE_FILE="/tmp/polybar-idle-inhibit"
SCRIPT="/home/jeremy/.config/polybar/scripts/idle-inhibit.sh"

case "$1" in
    toggle)
        if [ -f "$STATE_FILE" ]; then
            xset s 900 dpms 600 600 600
            rm -f "$STATE_FILE"
        else
            xset s off -dpms
            touch "$STATE_FILE"
        fi
        ;;
    *)
        if [ -f "$STATE_FILE" ]; then
            echo "%{A1:$SCRIPT toggle:}%{F#e0af68}AWAKE%{F-}%{A}"
        else
            echo "%{A1:$SCRIPT toggle:}%{F#6C6F93}IDLE%{F-}%{A}"
        fi
        ;;
esac
