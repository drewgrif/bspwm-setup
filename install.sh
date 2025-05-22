#!/bin/bash

# ============================================
# JustAGuy Linux - BSPWM Automated Setup Script
# https://github.com/drewgrif/bspwm-setup
# ============================================

LOG_FILE="$HOME/justaguylinux-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

CLONED_DIR="$HOME/bspwm-setup"
CONFIG_DIR="$HOME/.config/bspwm"
INSTALL_DIR="$HOME/installation"
BUTTERSCRIPTS_REPO="https://github.com/drewgrif/butterscripts"

# Create a unique base temporary directory for this run
MAIN_TEMP_DIR="/tmp/justaguylinux_$(date +%s)_$$"
mkdir -p "$MAIN_TEMP_DIR"

command_exists() {
    command -v "$1" &>/dev/null
}

# ============================================
# Error Handling
# ============================================
die() {
    echo "ERROR: $*" >&2
    exit 1
}

# ============================================
# Temporary Directory Management
# ============================================
create_temp_dir() {
    local name="$1"
    local temp_dir="$MAIN_TEMP_DIR/$name"
    mkdir -p "$temp_dir"
    echo "$temp_dir"
}

# Clean up all temporary directories on exit (success or failure)
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$MAIN_TEMP_DIR"
    rm -rf "$INSTALL_DIR"
    echo "Cleanup completed."
}
trap cleanup EXIT

# ============================================
# Script Fetching Functions
# ============================================
get_butterscript() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local temp_script="$MAIN_TEMP_DIR/scripts/$script_name"
    
    # Create directory for downloaded scripts
    mkdir -p "$MAIN_TEMP_DIR/scripts"
    
    echo "Fetching script: $script_path from butterscripts repository..."
    
    # Quietly download the script
    wget -q -O "$temp_script" "https://raw.githubusercontent.com/drewgrif/butterscripts/main/$script_path"
    local wget_status=$?
    
    # Check if the download was successful
    if [ $wget_status -ne 0 ] || [ ! -f "$temp_script" ] || [ ! -s "$temp_script" ]; then
        echo "ERROR: Failed to download script: $script_path (wget status: $wget_status)"
        return 1
    fi
    
    # Fix line endings
    sed -i 's/\r$//' "$temp_script" 2>/dev/null
    
    # Make executable
    chmod +x "$temp_script"
    
    # Success - return 0 instead of the path
    return 0
}

run_butterscript() {
    local script_path="$1"
    local script_name=$(basename "$script_path" .sh)
    local script_file="$MAIN_TEMP_DIR/scripts/$(basename "$script_path")"
    
    echo "Preparing to run: $script_path"
    
    # Download the script
    get_butterscript "$script_path"
    local get_status=$?
    
    if [ $get_status -ne 0 ]; then
        echo "ERROR: Failed to download script: $script_path"
        return 1
    fi
    
    # Check that the file exists directly
    if [ ! -f "$script_file" ]; then
        echo "ERROR: Script file does not exist: $script_file"
        return 1
    fi
    
    # Create a temporary directory for the script to use
    local script_temp_dir="$MAIN_TEMP_DIR/${script_name}_workdir"
    mkdir -p "$script_temp_dir"
    
    echo "Running script: $script_path"
    echo "Script file: $script_file"
    echo "Work directory: $script_temp_dir"
    
    # Run the script
    SCRIPT_TEMP_DIR="$script_temp_dir" bash "$script_file"
    local run_status=$?
    
    if [ $run_status -ne 0 ]; then
        echo "ERROR: Script execution failed with status: $run_status"
        return 1
    fi
    
    echo "Script execution completed successfully."
    return 0
}

# ============================================
# Confirm User Intention
# ============================================
clear
echo "
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |j|u|s|t|a|g|u|y|l|i|n|u|x| 
 +-+-+-+-+-+-+-+-+-+-+-+-+-+ 
 |b|s|p|w|m| | |s|c|r|i|p|t|  
 +-+-+-+-+-+-+-+-+-+-+-+-+-+                                                                            
"

echo "This script will install and configure BSPWM on your Debian system."
read -p "Do you want to continue? (y/n) " confirm
[[ ! "$confirm" =~ ^[Yy]$ ]] && die "Installation aborted."

sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean

# ============================================
# Install Required Packages
# ============================================
install_packages() {
    echo "Installing required packages..."
    sudo apt-get install -y xorg xorg-dev xbacklight xbindkeys xvkbd xinput build-essential bspwm sxhkd polybar network-manager-gnome pamixer thunar thunar-archive-plugin thunar-volman lxappearance dialog mtools smbclient cifs-utils avahi-daemon acpi acpid gvfs-backends xfce4-power-manager pavucontrol pulsemixer feh fonts-recommended fonts-font-awesome fonts-terminus exa suckless-tools flameshot qimgv rofi dunst libnotify-bin xdotool unzip libnotify-dev firefox-esr pipewire-audio nala micro xdg-user-dirs-gtk  || echo "Warning: Package installation failed."
    echo "Package installation completed."
}

install_reqs() {
    echo "Updating package lists and installing required dependencies..."
    sudo apt-get install -y cmake meson ninja-build curl pkg-config || { echo "Package installation failed."; exit 1; }
}

# ============================================
# Enable System Services
# ============================================
enable_services() {
    echo "Enabling required services..."
    sudo systemctl enable avahi-daemon || echo "Warning: Failed to enable avahi-daemon."
    sudo systemctl enable acpid || echo "Warning: Failed to enable acpid."
}

# ============================================
# Set Up User Directories
# ============================================
setup_user_dirs() {
    xdg-user-dirs-update
    mkdir -p ~/Screenshots/
}

# ============================================
# Check for Existing BSPWM Config
# ============================================
check_bspwm() {
    if [ -d "$CONFIG_DIR" ]; then
        echo "An existing ~/.config/bspwm directory was found."
        read -p "Backup existing configuration? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            backup_dir="$HOME/.config/bspwm_backup_$(date +%Y-%m-%d_%H-%M-%S)"
            mv "$CONFIG_DIR" "$backup_dir" || die "Failed to backup existing config."
            echo "Backup saved to $backup_dir"
        fi
    fi
}

# ============================================
# Move Config Files
# ============================================
setup_bspwm_config() {
    mkdir -p "$CONFIG_DIR"
    cp -r "$CLONED_DIR/bspwmrc" "$CONFIG_DIR/" || echo "Warning: Failed to copy bspwmrc."
    for dir in dunst fonts picom polybar rofi scripts sxhkd wallpaper; do
        cp -r "$CLONED_DIR/$dir" "$CONFIG_DIR/" || echo "Warning: Failed to copy $dir."
    done
    
    echo "BSPWM configuration files copied successfully."
}

# ============================================
# Install ft-picom
# ============================================
install_ftlabs_picom() {
    run_butterscript "setup/install_picom.sh"
}

# ============================================
# Install Wezterm
# ============================================
install_wezterm() {
    run_butterscript "wezterm/install_wezterm.sh"
}

# ============================================
# Install st
# ============================================
install_st() {
    run_butterscript "st/install_st.sh"
}

# ============================================
# Install Fonts
# ============================================
install_fonts() {
    echo "Installing fonts..."
    run_butterscript "theming/install_nerdfonts.sh"
}

# ============================================
# Install GTK Theme & Icons
# ============================================
install_theming() {
    run_butterscript "theming/install_theme.sh"
}

# ============================================
# Install Login Manager
# ============================================
install_displaymanager() {
    run_butterscript "system/install_lightdm.sh"
}

# ============================================
# Replace .bashrc
# ============================================
replace_bashrc() {
    run_butterscript "system/add_bashrc.sh"
}

# ============================================
# Install Optional Packages
# ============================================
install_optionals() {
    run_butterscript "setup/optional_tools.sh"
}

# ============================================
# Main Execution
# ============================================
install_packages
install_reqs
enable_services
setup_user_dirs
check_bspwm
setup_bspwm_config
install_ftlabs_picom
install_wezterm
install_st
install_fonts
install_theming
install_displaymanager
replace_bashrc
install_optionals

echo "All installations completed successfully!"
