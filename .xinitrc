#!/bin/sh

export SXHKD_SHELL='/usr/bin/sh'
dbus-update-activation-environment --systemd DISPLAY

setxkbmap -option shift:both_capslock,lv3:ralt_switch &

if [ -n "$(xrandr --query | grep '^HDMI1 connected')" ]; then
    xrandr --output eDP1 --off --output DP1 --off --output HDMI1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI2 --off --output VIRTUAL1 --off
elif [ -n "$(xrandr --query | grep '^DP1 connected')" ]; then
    xrandr --output eDP1 --off --output DP1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
sxhkd &
wal -R &
while true ;
	do
	xmonad 2> ~/Documents/dwm.log
done

#exec bspwm
