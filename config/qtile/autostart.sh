#!/bin/sh
#xrandr --output DP-0 --mode 1920x1080 --rate 144 --primary &
#xrandr --output HDMI-0 --mode 1280x1024 --rate 75
sleep 1
wlr-randr --output DP-1 --mode 1920x1080@144.000000 --pos 0,0
wlr-randr  --output HDMI-A-1 --mode 1280x1024@75.025002 --pos 1920,0
AyuGram -startintray &
#feh --bg-fill --randomize ~/nixos-dotfiles/config/qtile/wallpaper/ &
#snixembed &
v2rayN &
