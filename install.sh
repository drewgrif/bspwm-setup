#!/bin/bash

clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."
    
    # Use apt to install git
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install git -y
    else
        echo "Cannot install Git automatically using apt. Please install Git manually and run this script again."
        exit 1
    fi
    
    # Check again if git is installed after attempting to install
    if ! command -v git &> /dev/null; then
        echo "Git installation failed. Please install Git manually and run this script again."
        exit 1
    fi
fi

echo "Git is installed. Continuing with the script..."

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
    nala \
    micro \
    feh \
    fonts-recommended \
    fonts-font-awesome \
    fonts-terminus \
    ttf-mscorefonts-installer \
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

# Enable services
sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

# Update user directories
xdg-user-dirs-update
mkdir -p ~/Screenshots/

# Run theming scripts using source
if [ -f ./theming/picom.sh ]; then
    echo "Running picom.sh..."
    source ~/.config/bspwm/theming/picom.sh
else
    echo "picom.sh not found!"
fi

if [ -f ./theming/nerdfonts.sh ]; then
    echo "Running nerdfonts.sh..."
    source ~/.config/bspwm/theming/nerdfonts.sh
else
    echo "nerdfonts.sh not found!"
fi

if [ -f ./theming/teal.sh ]; then
    echo "Running teal.sh..."
    source ~/.config/bspwm/theming/teal.sh
else
    echo "teal.sh not found!"
fi

if [ -f ./theming/update-gtk.sh ]; then
    echo "Running update-gtk.sh..."
    source ~/.config/bspwm/theming/update-gtk.sh
else
    echo "update-gtk.sh not found!"
fi

if [ -f ./scripts/fastfetch.sh ]; then
    echo "Running fastfetch.sh..."
    source ~/.config/bspwm/scripts/fastfetch.sh
else
    echo "fastfetch.sh not found!"
fi

# Source the Ghostty install script from the theming directory
if [ -f ./theming/ghostty.sh ]; then
    echo "Running install_ghostty.sh..."
    source ~/.config/bspwm/theming/ghostty.sh
else
    echo "ghostty.sh not found in the theming directory!"
fi

echo "Would you like to overwrite your current .bashrc with the justaguylinux .bashrc? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    if [[ -f ~/.bashrc ]]; then
        mv ~/.bashrc ~/.bashrc.bak
        echo "Your current .bashrc has been moved to .bashrc.bak"
    fi
    wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc
    source ~/.bashrc
    if [[ $? -eq 0 ]]; then
        echo "justaguylinux .bashrc has been copied to ~/.bashrc"
    else
        echo "Failed to download justaguylinux .bashrc"
    fi
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "No changes have been made to ~/.bashrc"
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi

echo "All scripts executed!"

