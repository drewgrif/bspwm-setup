#!/bin/bash

# Update package list
sudo apt update

# Install packages
sudo apt install -y \
    # (list of packages)

echo "Package installation complete!"

# Run theming scripts using source
if [ -f ./theming/picom.sh ]; then
    echo "Running picom.sh..."
    source ./theming/picom.sh
else
    echo "picom.sh not found!"
fi

if [ -f ./theming/nerdfonts.sh ]; then
    echo "Running nerdfonts.sh..."
    source ./theming/nerdfonts.sh
else
    echo "nerdfonts.sh not found!"
fi

if [ -f ./theming/teal.sh ]; then
    echo "Running teal.sh..."
    source ./theming/teal.sh
else
    echo "teal.sh not found!"
fi

if [ -f ./theming/update-gtk.sh ]; then
    echo "Running update-gtk.sh..."
    source ./theming/update-gtk.sh
else
    echo "update-gtk.sh not found!"
fi

# Source the Ghostty install script from the theming directory
if [ -f ./theming/ghostty.sh ]; then
    echo "Running install_ghostty.sh..."
    source ./theming/ghostty.sh
else
    echo "install_ghostty.sh not found in the theming directory!"
fi

echo "All scripts executed!"

