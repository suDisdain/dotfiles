#!/bin/sh

export SXHKD_SHELL='/usr/bin/sh'
export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
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


slock &
lxpolkit &
xss-lock slock &
sxhkd &
emacs --daemon &
ibus-daemon -drx &
exec bspwm
#exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
