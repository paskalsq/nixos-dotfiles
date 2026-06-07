#!/bin/sh
xrandr --output DP-0 --mode 1920x1080 --rate 144 --primary &
xrandr --output HDMI-0 --mode 1280x1024 --rate 75
AyuGram -startintray &
feh --bg-fill --randomize ~/nixos-dotfiles/config/qtile/wallpaper/ &
snixembed &
v2rayN &
