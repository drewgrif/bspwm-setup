#!/bin/bash

# Check if ghostty is already installed
if command -v ghostty >/dev/null 2>&1; then
    echo "Ghostty is already installed. Skipping installation."
else
    # Clone the repository into a temporary directory
    TEMP_DIR=$(mktemp -d)  # Create a temporary directory
    echo "Cloning the myghostty repository..."
    git clone https://github.com/drewgrif/myghostty "$TEMP_DIR/myghostty"

    # Navigate to the cloned directory and run the installation script
    if [ -f "$TEMP_DIR/myghostty/install_ghostty.sh" ]; then
        echo "Running install_ghostty.sh..."
        bash "$TEMP_DIR/myghostty/install_ghostty.sh"
    else
        echo "install_ghostty.sh not found!"
    fi

    # Copy the config file from the cloned directory to ~/.config/ghostty
    if [ -f "$TEMP_DIR/myghostty/config" ]; then  
        echo "Creating ~/.config/ghostty directory if it doesn't exist..."
        mkdir -p "$HOME/.config/ghostty"  # Create the directory if it doesn't exist
        echo "Copying config file to ~/.config/ghostty..."
        cp "$TEMP_DIR/myghostty/config" "$HOME/.config/ghostty/"
    else
        echo "Config file not found in the repository. Skipping config copy."
    fi

    # Clean up by removing the cloned repository
    echo "Removing the cloned repository..."
    rm -rf "$TEMP_DIR"
fi

echo "Ghostty script executed!"
