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

# Function to safely run commands
safe_run() {
    "$@" || { echo "Error: '$*' failed. Exiting."; exit 1; }
}

# Install a list of packages
install_packages() {
    echo "Installing required packages..."
    safe_run apt install -y \
        xorg xbacklight xbindkeys xvkbd xinput build-essential bspwm sxhkd polybar \
        network-manager network-manager-gnome pamixer thunar thunar-archive-plugin \
        thunar-volman file-roller lxappearance dialog mtools dosfstools avahi-daemon \
        acpi acpid gvfs-backends xfce4-power-manager pavucontrol pamixer pulsemixer \
        feh fonts-recommended fonts-font-awesome fonts-terminus ttf-mscorefonts-installer \
        papirus-icon-theme exa flameshot qimgv rofi dunst libnotify-bin xdotool unzip \
        libnotify-dev gdm3 geany geany-plugin-addons geany-plugin-git-changebar \
        geany-plugin-spellcheck geany-plugin-treebrowser geany-plugin-markdown \
        geany-plugin-insertnum geany-plugin-lineoperations geany-plugin-automark \
        nala micro --no-install-recommends
    echo "Package installation completed."
}

# Ensure Git is installed
if ! command_exists git; then
    echo "Git is not installed. Attempting to install..."
    safe_run apt install -y git
fi

# Enable necessary services
enable_services() {
    echo "Enabling required services..."
    safe_run systemctl enable avahi-daemon
    safe_run systemctl enable acpid
    echo "Services enabled."
}

# Update user directories and create Screenshots folder
setup_user_dirs() {
    echo "Updating user directories..."
    safe_run xdg-user-dirs-update
    mkdir -p ~/Screenshots/
    echo "User directories updated."
}

# Install Picom compositor if not already installed
install_picom() {
    if command_exists picom; then
        echo "Picom is already installed. Skipping installation."
    else
        echo "Installing Picom..."
        safe_run apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev \
            libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev \
            libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev \
            libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev \
            libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev \
            libxext-dev meson ninja-build uthash-dev

        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/FT-Labs/picom "$TEMP_DIR/picom"
        cd "$TEMP_DIR/picom" || return 1
        safe_run meson setup --buildtype=release build
        safe_run ninja -C build
        safe_run ninja -C build install
        rm -rf "$TEMP_DIR"
        echo "Picom installation complete."
    fi
}

# Install fonts
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
            wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$font.zip" -P /tmp || { echo "Error downloading font $font."; exit 1; }
            unzip -q /tmp/$font.zip -d ~/.local/share/fonts/$font/
            rm /tmp/$font.zip
        fi
    done

    # Add custom TTF fonts
    cp ../fonts/* ~/.local/share/fonts
    fc-cache -f
    echo "Font installation completed."
}

# Install Fastfetch
install_fastfetch() {
    echo "Installing Fastfetch..."
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT

    git clone https://github.com/fastfetch-cli/fastfetch "$TEMP_DIR/fastfetch"
    cd "$TEMP_DIR/fastfetch" || return 1
    safe_run cmake .
    chmod +x run.sh
    ./run.sh
    mv build/fastfetch /usr/local/bin/
    echo "Fastfetch installation complete."
}

# Install ghostty
install_ghostty() {
    echo "Installing Ghostty..."
    if command_exists ghostty; then
        echo "Ghostty is already installed. Skipping installation."
    else
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/drewgrif/myghostty "$TEMP_DIR/myghostty"
        if [ -f "$TEMP_DIR/myghostty/install_ghostty.sh" ]; then
            bash "$TEMP_DIR/myghostty/install_ghostty.sh"
        fi
        mkdir -p "$HOME/.config/ghostty"
        cp "$TEMP_DIR/myghostty/config" "$HOME/.config/ghostty/"
        rm -rf "$TEMP_DIR"
        echo "Ghostty installation completed."
    fi
}

# Install GTK themes
install_themes() {
    echo "Installing GTK themes..."
    themes=( "Arc-Theme" "Materia" "Adwaita" )

    for theme in "${themes[@]}"; do
        if [ -d "/usr/share/themes/$theme" ]; then
            echo "Theme $theme is already installed. Skipping."
        else
            echo "Installing theme: $theme"
            sudo apt install -y "$theme" || { echo "Error installing theme $theme."; exit 1; }
        fi
    done
    echo "Theme installation completed."
}

# Modify GTK settings
modify_gtk_settings() {
    echo "Modifying GTK settings..."
    # Set GTK theme
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Darker"
    # Set icon theme
    gsettings set org.gnome.desktop.interface icon-theme "Papirus"
    # Set cursor theme
    gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
    # Set font settings
    gsettings set org.gnome.desktop.interface font-name "Ubuntu 11"
    echo "GTK settings modified."
}

# Main script execution
install_packages
enable_services
setup_user_dirs
install_picom
install_fonts
install_fastfetch
install_ghostty
install_themes
modify_gtk_settings

# Prompt for .bashrc replacement
echo "Would you like to overwrite your current .bashrc with the justaguylinux .bashrc? (y/n)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    if [ -f ~/.bashrc ]; then
        mv ~/.bashrc ~/.bashrc.bak
        echo "Backup of your current .bashrc created as .bashrc.bak."
    fi
    wget -O ~/.bashrc https://raw.githubusercontent.com/drewgrif/jag_dots/main/.bashrc
    source ~/.bashrc
    echo "justaguylinux .bashrc has been installed."
elif [[ "$response" =~ ^[Nn]$ ]]; then
    echo "No changes made to .bashrc."
else
    echo "Invalid input. Please enter 'y' or 'n'."
fi

echo "Script execution completed!"
