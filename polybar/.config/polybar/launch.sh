#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar on each connected monitor
monitors=$(xrandr --query | grep " connected" | cut -d" " -f1)

# Put tray on DP-1 if connected, otherwise fall back to eDP-1
if echo "$monitors" | grep -q "DP-1"; then
    tray_monitor="DP-1"
else
    tray_monitor="eDP-1"
fi

for m in $monitors; do
    tray=none
    [ "$m" = "$tray_monitor" ] && tray=right
    MONITOR=$m TRAY_POSITION=$tray polybar mybar 2>&1 | tee -a /tmp/polybar-$m.log & disown
done

echo "Bars launched..."
