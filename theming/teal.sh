#!/bin/sh

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
