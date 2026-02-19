#!/bin/bash

# Don't lock if already locked
pgrep -x swaylock && exit 0

LOCK_ARGS="-f"

# Capture each output separately for correct per-monitor lock images
for output in $(swaymsg -t get_outputs --raw | jq -r '.[] | select(.active) | .name'); do
    grim -o "$output" "/tmp/lock-${output}.png"
    magick "/tmp/lock-${output}.png" -blur 0x8 "/tmp/lock-${output}-blur.png"
    LOCK_ARGS="$LOCK_ARGS -i ${output}:/tmp/lock-${output}-blur.png"
done

swaylock $LOCK_ARGS
