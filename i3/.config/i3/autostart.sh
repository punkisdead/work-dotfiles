# Enable external monitor: DP-1 (LG 45GX950A ultrawide) to the right of laptop
xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --output DP-1 --mode 3440x1440 --rate 50 --right-of eDP-1 --dpi 120 &

killall xsettingsd
xsettingsd &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

picom -b &
dunst &

killall nm-applet
nm-applet &
killall blueman-applet
blueman-applet &

killall volumeicon
volumeicon &

numlockx on &

# Screen lock on idle (15 min) and before sleep
xset s 900 5
killall xss-lock
xss-lock --transfer-sleep-lock -- i3lock --nofork &

killall sxhkd
sxhkd -c ~/.config/sxhkd/sxhkdrc &

#ibus-daemon -drx &

