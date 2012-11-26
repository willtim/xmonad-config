#!/usr/bin/env bash

# NEEDS TO BE STARTED BY LIGHTDM OR GDM
# IF CONSOLEKIT SUPPORT NEEDED

xcompmgr &

xrdb -merge .Xresources

# Remap that useless capslock key
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# nice background image - feh works with xcompmgr
feh --bg-scale "$HOME/Pictures/Wallpaper/DSC_0155.jpg"

trayer --edge top --align right --SetDockType true --expand true --widthtype pixel --width 96 --transparent true --alpha 0 --tint 0x000000 --heighttype pixel --height 18 & 

/usr/lib/notification-daemon/notification-daemon &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

xscreensaver -no-splash &

# Use Gnome keyring for e.g. wireless network keys
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME_KEYRING_CONTROL
export GNOME_KEYRING_SOCKET
export GNOME_KEYRING_PID

# Make QT4 apps look decent
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ -x /usr/bin/nm-applet ] ; then
   sleep 1
   nm-applet --sm-disable &
fi

dropbox start &

skype & 

exec xmonad
