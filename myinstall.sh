#!/bin/bash

# ========================================
# Script Banner and Intro
# ========================================
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t|  
 +-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                            
"

INSTALL_DIR="$HOME/installation"
ZIG_REQUIRED_VERSION="0.13.0"
ZIG_BINARY="/usr/local/bin/zig"
GTK_THEME="https://github.com/vinceliuice/Colloid-gtk-theme.git"
ICON_THEME="https://github.com/vinceliuice/Colloid-icon-theme.git"

# ========================================
# Initialization
# ========================================
mkdir -p "$INSTALL_DIR" || { echo "Failed to create installation directory."; exit 1; }

# Cleanup function
cleanup() {
    rm -rf "$INSTALL_DIR"
    echo "Installation directory removed."
}
trap cleanup EXIT

# ========================================
# Package Installation Section
# ========================================
# Install required packages
install_packages() {
    echo "Installing required packages..."
    sudo apt install -y \
        xorg xbacklight xbindkeys xvkbd xinput build-essential bspwm sxhkd polybar \
        network-manager network-manager-gnome pamixer thunar thunar-archive-plugin \
        thunar-volman file-roller lxappearance dialog mtools dosfstools avahi-daemon \
        acpi acpid gvfs-backends xfce4-power-manager pavucontrol pamixer pulsemixer \
        feh fonts-recommended fonts-font-awesome fonts-terminus ttf-mscorefonts-installer \
        papirus-icon-theme exa flameshot qimgv rofi dunst libnotify-bin xdotool unzip \
        libnotify-dev firefox-esr geany geany-plugin-addons geany-plugin-git-changebar \
        geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-markdown \
        geany-plugin-insertnum geany-plugin-lineoperations geany-plugin-automark \
        nala micro xdg-user-dirs-gtk \
        --no-install-recommends gdm3 || echo "Warning: Package installation failed."
    echo "Package installation completed."
}

# ========================================
# Enabling Required Services
# ========================================
# Enables system services such as Avahi and ACPI
# ------------------------------------------------
# This section ensures that necessary services like Avahi (for network discovery)
# and ACPI (for power management) are enabled on the system for proper operation.
enable_services() {
    echo "Enabling required services..."
    systemctl enable avahi-daemon || echo "Warning: Failed to enable avahi-daemon."
    systemctl enable acpid || echo "Warning: Failed to enable acpid."
    echo "Services enabled."
}

# ========================================
# User Directory Setup
# ========================================
# Sets up user directories (e.g., Downloads, Music, Pictures) and creates
# a Screenshots folder for easy screenshot management
# ---------------------------------------------------------------
# This section updates the user directories (such as `Downloads` or `Documents`) 
# using the `xdg-user-dirs-update` utility. It also ensures a `Screenshots` 
# directory exists in the user's home directory for managing screenshots.
setup_user_dirs() {
    echo "Updating user directories..."
    xdg-user-dirs-update || echo "Warning: Failed to update user directories."
    mkdir -p ~/Screenshots/ || echo "Warning: Failed to create Screenshots directory."
    echo "User directories updated."

# ========================================
# Utility Functions
# ========================================
command_exists() {
    command -v "$1" &>/dev/null
}

install_packages() {
    echo "Updating package lists and installing required dependencies..."
    sudo apt install -y \
        build-essential cmake meson ninja-build git wget curl \
        libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
        libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev \
        libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev \
        libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev \
        libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
        libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev \
        libxcb-xfixes0-dev libxext-dev uthash-dev \
        libgtk-4-dev libadwaita-1-dev \
        pkg-config python3 python3-pip || { echo "Package installation failed."; exit 1; }
}

# ========================================
# Picom Installation
# ========================================
install_picom() {
    if command_exists picom; then
        echo "Picom is already installed. Skipping installation."
    else
        echo "Installing Picom..."
        git clone https://github.com/FT-Labs/picom "$INSTALL_DIR/picom" || { echo "Failed to clone Picom repository."; return 1; }
        cd "$INSTALL_DIR/picom" || { echo "Failed to access Picom directory."; return 1; }
        meson setup --buildtype=release build || { echo "Meson setup failed."; return 1; }
        ninja -C build || { echo "Ninja build failed."; return 1; }
        sudo ninja -C build install || { echo "Ninja install failed."; return 1; }
        echo "Picom installation complete."
    fi
}

# ========================================
# Fastfetch Installation
# ========================================
install_fastfetch() {
    echo "Installing Fastfetch..."
    git clone https://github.com/fastfetch-cli/fastfetch "$INSTALL_DIR/fastfetch" || { echo "Failed to clone Fastfetch repository."; return 1; }
    cd "$INSTALL_DIR/fastfetch" || { echo "Failed to access Fastfetch directory."; return 1; }
    cmake -S . -B build || { echo "CMake configuration failed."; return 1; }
    cmake --build build || { echo "Build process failed."; return 1; }
    sudo mv build/fastfetch /usr/local/bin/ || { echo "Failed to move Fastfetch binary to /usr/local/bin/."; return 1; }
    echo "Fastfetch installation complete."
}


# ========================================
# Ghostty Installation
# ========================================
install_ghostty() {
    if command_exists ghostty; then
        echo "Ghostty is already installed. Skipping installation."
    else
        echo "Installing Ghostty..."
        git clone https://github.com/drewgrif/myghostty "$INSTALL_DIR/myghostty" || { echo "Failed to clone Ghostty repository."; return 1; }
        if [ -f "$INSTALL_DIR/myghostty/install_ghostty.sh" ]; then
            bash "$INSTALL_DIR/myghostty/install_ghostty.sh" || { echo "Ghostty installation script failed."; return 1; }
        fi
        mkdir -p "$HOME/.config/ghostty"
        cp "$INSTALL_DIR/myghostty/config" "$HOME/.config/ghostty/" || { echo "Failed to copy Ghostty config."; return 1; }
        echo "Ghostty installation complete."
    fi
}

# ========================================
# Font Installation
# ========================================
# Installs a list of selected fonts for better terminal and GUI appearance
# ----------------------------------------------------------------------
# This section installs various fonts including `Nerd Fonts` from GitHub releases,
# and copies custom TTF fonts into the local fonts directory. It then rebuilds 
# the font cache using `fc-cache`.
install_fonts() {
    echo "Installing fonts..."
    mkdir -p ~/.local/share/fonts
    fonts=( 
        "FiraCode" "Hack" "JetBrainsMono" 
        "RobotoMono" "SourceCodePro" "UbuntuMono"
    )

    for font in "${fonts[@]}"; do
        if [ -d ~/.local/share/fonts/$font ]; then
            echo "Font $font is already installed. Skipping."
        else
            echo "Installing font: $font"
            wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$font.zip" -P /tmp || { echo "Warning: Error downloading font $font."; continue; }
            unzip -q /tmp/$font.zip -d ~/.local/share/fonts/$font/ || echo "Warning: Error extracting font $font."
            rm /tmp/$font.zip
        fi
    done

    # Add custom TTF fonts
    cp ~/.config/bspwm/fonts/* ~/.local/share/fonts || echo "Warning: Error copying custom TTF fonts."
    fc-cache -f || echo "Warning: Error rebuilding font cache."
    echo "Font installation completed."
}

# ========================================
# GTK Theme Installation
# ========================================
install_theming() {
    
# Install GTK Theme
echo "Installing GTK theme..."
git clone "$GTK_THEME" "$INSTALL_DIR/Colloid-gtk-theme"
cd "$INSTALL_DIR/Colloid-gtk-theme"
yes | ./install.sh -c dark -t teal --tweaks black || die "Failed to install GTK theme."

# Install Icon Theme
echo "Installing Icon theme..."
git clone "$ICON_THEME" "$INSTALL_DIR/Colloid-icon-theme"
cd "$INSTALL_DIR/Colloid-icon-theme"
./install.sh -t teal -s default gruvbox everforest || die "Failed to install Icon theme."
}

# ========================================
# Main Script Execution
# ========================================
echo "Starting installation process..."

install_packages

install_picom
install_fastfetch
install_ghostty
install_fonts
install_theming


echo "All installations completed successfully!"
