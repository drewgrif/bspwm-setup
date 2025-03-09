#!/bin/bash

# Simple script to handle a DIY shutdown menu with rofi.
#
# Requirements:
# - rofi
# - systemd (can be replaced for other init systems if needed)
#
# Instructions:
# - Save this file as power.sh
# - Make it executable: chmod +x /path/to/power.sh
# - Run it

ROFI_THEME="$HOME/.config/suckless/rofi/power.rasi"

chosen=$(echo -e "[Cancel]\nLogout\nShutdown\nReboot" | \
    rofi -dmenu -i -p "Power Menu" -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME")

case "$chosen" in
    "Logout") pkill dwm ;;
    "Shutdown") systemctl poweroff ;;
    "Reboot") systemctl reboot ;;
    *) exit 0 ;; # Exit on cancel or invalid input
esac

