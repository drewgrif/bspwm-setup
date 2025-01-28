#!/bin/bash

# ========================================
# Script Banner and Intro
# ========================================
# Clears the screen and displays the script banner
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t|  +-+-+-+-+-+-++-+-+-+-+-+-+                                                                            
"

# ========================================
# Utility Functions
# ========================================
# Function to check if a command exists
# ------------------------------------
# This function verifies if a command is available in the user's PATH.
command_exists() {
    command -v "$1" &>/dev/null
}



# ========================================
# Package Installation Section
# ========================================
# Installs required packages for a functioning Linux setup
# --------------------------------------------------------
# This function installs essential packages for the system including
# utilities for window management (bspwm, sxhkd), network management,
# power management, file managers (Thunar), and various development tools.
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
# Git Installation Check
# ========================================
# Ensures that Git is installed before cloning repositories
# ---------------------------------------------------------
# This section checks if Git is installed on the system. If not, it attempts
# to install it before continuing with any repository cloning steps.
if ! command_exists git; then
    echo "Git is not installed. Attempting to install..."
    sudo apt install -y git || echo "Warning: Git installation failed."
fi

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
}

# ========================================
# Picom Installation
# ========================================
# Installs Picom (a compositor) from source if it's not already installed
# ----------------------------------------------------------------------
# This section checks whether Picom is installed and if not, installs it from 
# source by cloning the repository and building it using Meson and Ninja.
install_picom() {
    if command_exists picom; then
        echo "Picom is already installed. Skipping installation."
    else
        echo "Installing Picom..."
        sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
            libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev \
            libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev \
            libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
            libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev \
            libxext-dev meson ninja-build uthash-dev || echo "Warning: Picom dependencies installation failed."
        
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/FT-Labs/picom "$TEMP_DIR/picom" || echo "Warning: Failed to clone Picom repository."
        cd "$TEMP_DIR/picom" || echo "Warning: Failed to access Picom directory."
        meson setup --buildtype=release build || echo "Warning: Meson setup failed."
        ninja -C build || echo "Warning: Ninja build failed."
        ninja -C build install || echo "Warning: Ninja install failed."
        rm -rf "$TEMP_DIR"
        echo "Picom installation complete."
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
    cp ~/fonts/* ~/.local/share/fonts || echo "Warning: Error copying custom TTF fonts."
    fc-cache -f || echo "Warning: Error rebuilding font cache."
    echo "Font installation completed."
}

# ========================================
# Fastfetch Installation
# ========================================
# Installs Fastfetch for displaying system info in the terminal
# ------------------------------------------------------------
# This section installs `Fastfetch` (a system information display tool) by 
# cloning the repository, building it from source, and placing the binary in
# `/usr/local/bin`.
install_fastfetch() {
    echo "Installing Fastfetch..."
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT

    git clone https://github.com/fastfetch-cli/fastfetch "$TEMP_DIR/fastfetch" || echo "Warning: Failed to clone Fastfetch repository."
    cd "$TEMP_DIR/fastfetch" || echo "Warning: Failed to access Fastfetch directory."
    cmake . || echo "Warning: CMake failed."
    chmod +x run.sh || echo "Warning: Failed to make run.sh executable."
    ./run.sh || echo "Warning: Fastfetch run failed."
    mv build/fastfetch /usr/local/bin/ || echo "Warning: Failed to move Fastfetch binary to /usr/local/bin/"
    echo "Fastfetch installation complete."
}

# ========================================
# Ghostty Installation
# ========================================
# Installs Ghostty, a TTY-based notification system
# --------------------------------------------------
# This section installs `Ghostty` by cloning the repository and running the 
# installation script. It also copies the configuration file to the appropriate 
# directory in the user's home directory.
install_ghostty() {
    echo "Installing Ghostty..."
    if command_exists ghostty; then
        echo "Ghostty is already installed. Skipping installation."
    else
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/drewgrif/myghostty "$TEMP_DIR/myghostty" || echo "Warning: Failed to clone Ghostty repository."
        if [ -f "$TEMP_DIR/myghostty/install_ghostty.sh" ]; then
            bash "$TEMP_DIR/myghostty/install_ghostty.sh" || echo "Warning: Ghostty installation script failed."
        fi
        mkdir -p "$HOME/.config/ghostty"
        cp "$TEMP_DIR/myghostty/config" "$HOME/.config/ghostty/" || echo "Warning: Failed to copy Ghostty config."
        rm -rf "$TEMP_DIR"
        echo "Ghostty installation completed."
    fi
}

# ========================================
# Theme Installation (GTK & Icon)
# ========================================
# Installs the Colloid GTK theme and Colloid icon theme
# ------------------------------------------------------
# This section installs the Colloid GTK and icon themes from GitHub, with the 
# specified color scheme and tweaks. It clones the respective repositories 
# into temporary directories and removes them after installation.
install_themes() {
    TEMP_DIR_GTK="/tmp/Colloid-gtk-theme"
    TEMP_DIR_ICONS="/tmp/Colloid-icon-theme"

    # Check and install GTK theme
    if [ -d "$HOME/.themes/Colloid-Dark" ]; then
        echo "Colloid-gtk-theme is already installed."
    else
        echo "Installing Colloid-gtk-theme..."
        git clone https://github.com/vinceliuice/Colloid-gtk-theme.git "$TEMP_DIR_GTK" || echo "Warning: Failed to clone Colloid GTK theme."
        cd "$TEMP_DIR_GTK" || { echo "Warning: Failed to access GTK theme directory"; exit 1; }
        yes | ./install.sh -c dark -t teal --tweaks black || echo "Warning: Colloid GTK theme installation failed."
        rm -rf "$TEMP_DIR_GTK"
        echo "Colloid-gtk-theme installation completed."
    fi

    # Check and install icon theme
    if [ -d "$HOME/.icons/Colloid" ]; then
        echo "Colloid-icon-theme is already installed."
    else
        echo "Installing Colloid-icon-theme..."
        git clone https://github.com/vinceliuice/Colloid-icon-theme.git "$TEMP_DIR_ICONS" || echo "Warning: Failed to clone Colloid icon theme."
        cd "$TEMP_DIR_ICONS" || { echo "Warning: Failed to access icon theme directory"; exit 1; }
        ./install.sh -t teal -s default gruvbox everforest || echo "Warning: Colloid icon theme installation failed."
        rm -rf "$TEMP_DIR_ICONS"
        echo "Colloid-icon-theme installation completed."
    fi
}

# ========================================
# Modify GTK Settings
# ========================================
# Modifies the GTK settings to use the installed themes and icons
# --------------------------------------------------------------
# This section configures the GTK settings to use the Colloid themes, 
# sets the cursor, font, and other preferences using `gsettings`.
modify_gtk_settings() {
    echo "Modifying GTK settings..."
    gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Teal-Dark" || echo "Warning: Failed to set GTK theme."
    gsettings set org.gnome.desktop.interface icon-theme "Colloid-Teal-Everforest-Dark" || echo "Warning: Failed to set icon theme."
    gsettings set org.gnome.desktop.interface cursor-theme "Adwaita" || echo "Warning: Failed to set cursor theme."
    gsettings set org.gnome.desktop.interface font-name "Ubuntu 11" || echo "Warning: Failed to set font."
    echo "GTK settings modified."
}

# ========================================
# .bashrc Replacement Prompt
# ========================================
# Asks the user if they want to replace the .bashrc file with the one 
# provided by justaguylinux
# -------------------------------------------------------------------
# This section prompts the user whether they'd like to replace their 
# existing `.bashrc` with a predefined version from GitHub. If they agree, 
# the `.bashrc` is downloaded and replaced, while the old one is backed up.
replace_bashrc() {
    echo "Do you want to replace your .bashrc with the default justaguylinux version? (y/n)"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        cp ~/.bashrc ~/.bashrc.bak || echo "Warning: Failed to backup .bashrc."
        wget -q https://raw.githubusercontent.com/justaguylinux/.bashrc -O ~/.bashrc || echo "Warning: Failed to replace .bashrc."
        echo ".bashrc replaced. Backup saved as .bashrc.bak."
    else
        echo ".bashrc not replaced."
    fi
}

# ========================================
# Script Execution Flow
# ========================================
# Call the functions in the correct order to set up the system
# -----------------------------------------------------------
install_packages
enable_services
setup_user_dirs
install_picom
install_fonts
install_fastfetch
install_ghostty
install_themes
modify_gtk_settings
replace_bashrc
