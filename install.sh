#!/bin/bash

clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
"
# Update user directories
xdg-user-dirs-update
mkdir -p ~/Screenshots/


# Base directory of the script
base_dir=$(dirname "$(realpath "$0")")

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Attempting to install Git..."
    if ! apt update && apt install git -y; then
        echo "Error: Failed to install Git."
        return 1
    fi
fi

echo "Git is installed. Continuing with the script..."

# Update package list and install required packages
apt update && apt install -y \
    xorg \
    xbacklight \
    xbindkeys \
    xvkbd \
    xinput \
    build-essential \
    bspwm \
    sxhkd \
    polybar \
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
    nala \
    micro

echo "Packages have been installed."

# Enable necessary services
systemctl enable avahi-daemon
systemctl enable acpid

# Run theming scripts relative to the script's directory
theming_dir="$base_dir/theming"

declare -a theme_scripts=("picom.sh" "nerdfonts.sh" "teal.sh" "update-gtk.sh")
for script in "${theme_scripts[@]}"; do
    if [ -f "$theming_dir/$script" ]; then
        echo "Running $script..."
        source "$theming_dir/$script"
    else
        echo "Error: $script not found in $theming_dir!"
    fi
done

# Run additional scripts relative to the script's directory
scripts_dir="$base_dir/scripts"

if [ -f "$scripts_dir/fastfetch.sh" ]; then
    echo "Running fastfetch.sh..."
    source "$scripts_dir/fastfetch.sh"
else
    echo "Error: fastfetch.sh not found in $scripts_dir!"
fi

if [ -f "$theming_dir/ghostty.sh" ]; then
    echo "Running ghostty.sh..."
    source "$theming_dir/ghostty.sh"
else
    echo "Error: ghostty.sh not found in $theming_dir!"
fi

# Prompt to overwrite .bashrc
echo "Would you like to overwrite your current .bashrc with the justaguylinux .bashrc? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    if [ -f ~/.bashrc ]; then
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
return 0
