#!/bin/bash

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

