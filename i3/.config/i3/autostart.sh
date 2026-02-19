# Enable external monitor: DP-1 (LG 45GX950A ultrawide) to the right of laptop
xrandr --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --output DP-1 --mode 3440x1440 --rate 50 --right-of eDP-1 &

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

killall xfce4-power-manager 
xfce4-power-manager &

killall sxhkd
sxhkd -c ~/.config/sxhkd/sxhkdrc &

#ibus-daemon -drx &

