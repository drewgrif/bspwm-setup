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

# Set dynamic paths
CONFIG_DIR="${HOME}/.config/bspwm"
THEMING_DIR="${CONFIG_DIR}/theming"
SCRIPTS_DIR="${CONFIG_DIR}/scripts"

# Run theming scripts using source
for script in "picom.sh" "nerdfonts.sh" "teal.sh" "update-gtk.sh"; do
    if [ -f "${THEMING_DIR}/${script}" ]; then
        echo "Running ${script}..."
        source "${THEMING_DIR}/${script}"
    else
        echo "${script} not found in ${THEMING_DIR}!"
    fi
done

if [ -f "${SCRIPTS_DIR}/fastfetch.sh" ]; then
    echo "Running fastfetch.sh..."
    source "${SCRIPTS_DIR}/fastfetch.sh"
else
    echo "fastfetch.sh not found in ${SCRIPTS_DIR}!"
fi

if [ -f "${THEMING_DIR}/ghostty.sh" ]; then
    echo "Running ghostty.sh..."
    source "${THEMING_DIR}/ghostty.sh"
else
    echo "ghostty.sh not found in ${THEMING_DIR}!"
fi

# Overwrite .bashrc if requested
echo "Would you like to overwrite your current .bashrc with the justaguylinux .bashrc? (y/n)"
read response

if [[ "$response" =~ ^[Yy]$ ]]; then
    if [[ -f ~/.bashrc ]]; then
        mv ~/.bashrc ~/.bashrc.bak
        echo "Your current .bashrc has been moved to .bashrc.bak"
    fi
    if wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc; then
        echo "justaguylinux .bashrc has been copied to ~/.bashrc"
        source ~/.bashrc
    else
        echo "Failed to download justaguylinux .bashrc"
    fi
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "No changes have been made to ~/.bashrc"
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi

echo "All scripts executed!"
