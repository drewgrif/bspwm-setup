#!/bin/bash

# Clear the screen for better visibility
clear

# Display script banner
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t| 
 +-+-+-+-+-+-+ +-+-+-+-+-+-+                                                                                                            
"

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Install a list of packages
install_packages() {
    echo "Installing required packages..."
    apt install -y \
        xorg xbacklight xbindkeys xvkbd xinput build-essential bspwm sxhkd polybar \
        network-manager network-manager-gnome pamixer thunar thunar-archive-plugin \
        thunar-volman file-roller lxappearance dialog mtools dosfstools avahi-daemon \
        acpi acpid gvfs-backends xfce4-power-manager pavucontrol pamixer pulsemixer \
        feh fonts-recommended fonts-font-awesome fonts-terminus ttf-mscorefonts-installer \
        papirus-icon-theme exa flameshot qimgv rofi dunst libnotify-bin xdotool unzip \
        libnotify-dev geany geany-plugin-addons geany-plugin-git-changebar \
        geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-markdown \
        geany-plugin-insertnum geany-plugin-lineoperations geany-plugin-automark \
        nala micro firefox-esr \
        --no-install-recommends gdm3
    echo "Package installation completed."
}

# Function to check if a directory exists
check_directory() {
    [ -d "$1" ] && return 0 || return 1
}

# Function to handle theme installation
install_theme() {
    local repo_url="$1"
    local clone_dir="$2"
    local install_script="$3"
    
    tmp_dir=$(mktemp -d) || return 1
    cd "$tmp_dir" || return 1
    git clone "$repo_url" || return 1
    cd "$clone_dir" || return 1
    $install_script
    rm -rf "$tmp_dir"
}

# Check if Colloid-icon-theme is installed
if check_directory "$HOME/.local/share/icons/Colloid-Dark"; then
    echo "Colloid-icon-theme is already installed."
else
    echo "Installing Colloid-icon-theme..."
    install_theme "https://github.com/vinceliuice/Colloid-icon-theme.git" "Colloid-icon-theme" "./install.sh -t teal -s default gruvbox everforest"
fi

# Check if Colloid-gtk-theme is installed
if check_directory "$HOME/.themes/Colloid-Dark"; then
    echo "Colloid-gtk-theme is already installed."
else
    echo "Installing Colloid-gtk-theme..."
    install_theme "https://github.com/vinceliuice/Colloid-gtk-theme.git" "Colloid-gtk-theme" "yes | ./install.sh -c dark -t teal --tweaks black"
fi

# Configure GTK settings
configure_gtk_settings() {
    echo "Configuring GTK settings..."

    # Ensure the directories exist
    mkdir -p ~/.config/gtk-3.0

    # Check if the settings.ini already exists and overwrite
    if [ -f ~/.config/gtk-3.0/settings.ini ]; then
        echo "settings.ini already exists, overwriting..."
    fi

    # Write to ~/.config/gtk-3.0/settings.ini
    cat << EOF > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Colloid-Teal-Dark
gtk-icon-theme-name=Colloid-Teal-Everforest-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

    # Check if the .gtkrc-2.0 already exists and overwrite
    if [ -f ~/.gtkrc-2.0 ]; then
        echo ".gtkrc-2.0 already exists, overwriting..."
    fi

    # Write to ~/.gtkrc-2.0
    cat << EOF > ~/.gtkrc-2.0
gtk-theme-name="Colloid-Teal-Dark"
gtk-icon-theme-name="Colloid-Teal-Everforest-Dark"
gtk-font-name="Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
EOF

    echo "GTK settings updated."
}

# Main script execution
install_packages
configure_gtk_settings

# Other functions remain unchanged
