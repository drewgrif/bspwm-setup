#!/bin/bash

# Clone the repository and run install_ghostty.sh
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

# Clean up by removing the cloned repository
echo "Removing the cloned repository..."
rm -rf "$TEMP_DIR"

echo "All scripts executed!"
