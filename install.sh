#!/bin/bash

clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
"

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
sudo apt update && apt install -y \
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

# Update user directories
xdg-user-dirs-update
mkdir -p ~/Screenshots/

########## Start of Picom #################

# Check if picom is already installed
if picom --version >/dev/null 2>&1; then
    echo "Picom is already installed. Skipping installation."
else
    # If picom is not installed, proceed with installation steps here
    echo "Picom is not installed. Installing..."

    # Install dependencies
    sudo apt update
    sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

    # Create a temporary directory and clone the repository
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/FT-Labs/picom "$TEMP_DIR/picom"
    cd "$TEMP_DIR/picom"

    # Build and install picom
    meson setup --buildtype=release build
    ninja -C build
    sudo ninja -C build install

    # Cleanup: Remove the temporary directory
    rm -rf "$TEMP_DIR"

    echo "Picom installation complete and temporary files cleaned up."
fi

########## End of Picom #################

########## Start  of Fonts #################
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if unzip is installed; if not, install it
if ! command_exists unzip; then
    echo "Installing unzip..."
    sudo apt install unzip -y
fi

# Create directory for fonts if it doesn't exist
mkdir -p ~/.local/share/fonts

# Array of font names
fonts=( 
    "FiraCode"  
    "Hack"  
    "JetBrainsMono"  
    "RobotoMono" 
    "SourceCodePro" 
    "UbuntuMono"
    # Add additional fonts here if needed
)

# Function to check if font directory exists
check_font_installed() {
    font_name=$1
    if [ -d ~/.local/share/fonts/$font_name ]; then
        echo "Font $font_name is already installed. Skipping."
        return 0  # Font already installed
    else
        return 1  # Font not installed
    fi
}

# Loop through each font, check if installed, and install if not
for font in "${fonts[@]}"
do
    if check_font_installed "$font"; then
        echo "Skipping installation of font: $font"
        continue  # Skip installation if font is already installed
    fi
    
    echo "Installing font: $font"
    wget -q --show-progress "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$font.zip" -P /tmp
    if [ $? -ne 0 ]; then
        echo "Failed to download font: $font"
        continue
    fi
    
    unzip -q /tmp/$font.zip -d ~/.local/share/fonts/$font/
    if [ $? -ne 0 ]; then
        echo "Failed to extract font: $font"
        continue
    fi
    
    rm /tmp/$font.zip
done

# Add additions TTF Fonts
cp ../fonts/* ~/.local/share/fonts

# Update font cache
fc-cache -f

echo "Fonts installation completed."

########## End of Fonts #################


########## Start of Fastfetch #################

# Run additional scripts relative to the script's directory
scripts_dir="$base_dir/scripts"

if [ -f "$scripts_dir/fastfetch.sh" ]; then
    echo "Running fastfetch.sh..."
    source "$scripts_dir/fastfetch.sh"
else
    echo "Error: fastfetch.sh not found in $scripts_dir!"
fi

########## End of Fastfetch #################

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
