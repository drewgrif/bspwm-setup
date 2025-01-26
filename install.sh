#!/bin/bash

# Update package list
sudo apt update

# Install packages
sudo apt install -y \
    xorg \
    xbacklight \
    xbindkeys \
    xvkbd \
    xinput \
    build-essential \
    git \
    network-manager \
    network-manager-gnome \
    pamixer \
    thunar \
    thunar-archive-plugin \
    thunar-volman \
    file-roller \
    lxappearance \
    dialog \
    mtools \
    dosfstools \
    avahi-daemon \
    acpi \
    acpid \
    gvfs-backends \
    xfce4-power-manager \
    pavucontrol \
    pamixer \
    pulsemixer \
    feh \
    fonts-recommended \
    fonts-font-awesome \
    fonts-terminus \
    papirus-icon-theme \
    exa \
    flameshot \
    qimgv \
    rofi \
    dunst \
    libnotify-bin \
    xdotool \
    unzip \
    libnotify-dev \
    --no-install-recommends gdm3 \
    geany \
    geany-plugin-addons \
    geany-plugin-git-changebar \
    geany-plugin-spellcheck \
    geany-plugin-treebrowser \
    geany-plugin-markdown \
    geany-plugin-insertnum \
    geany-plugin-lineoperations \
    geany-plugin-automark \
    bspwm \
    sxhkd \
    suckless-tools \
    polybar \
    tilix \
    firefox-esr

echo "Package installation complete!"

# Run theming scripts using source
if [ -f ./theming/picom.sh ]; then
    echo "Running picom.sh..."
    source ./theming/picom.sh
else
    echo "picom.sh not found!"
fi

if [ -f ./theming/nerdfonts.sh ]; then
    echo "Running nerdfonts.sh..."
    source ./theming/nerdfonts.sh
else
    echo "nerdfonts.sh not found!"
fi

if [ -f ./theming/teal.sh ]; then
    echo "Running teal.sh..."
    source ./theming/teal.sh
else
    echo "teal.sh not found!"
fi

if [ -f ./theming/update-gtk.sh ]; then
    echo "Running update-gtk.sh..."
    source ./theming/update-gtk.sh
else
    echo "update-gtk.sh not found!"
fi

# Source the Ghostty install script from the theming directory
if [ -f ./theming/ghostty.sh ]; then
    echo "Running install_ghostty.sh..."
    source ./theming/ghostty.sh
else
    echo "ghostty.sh not found in the theming directory!"
fi

echo "All scripts executed!"

