#!/bin/sh

# Define variables
ZEN_DIR="/opt/zen"
ZEN_BIN="/usr/bin/zen"
DESKTOP_FILE="/usr/share/applications/zen-browser.desktop"
TAR_FILE="zen-browser.tar.xz"

# Function to clean up old zen-browser installation
cleanup() {
    echo "Cleaning up old zen-browser installation..."
    sudo rm -rf "$ZEN_DIR"
    sudo rm -f "$ZEN_BIN"
    sudo rm -f "$DESKTOP_FILE"
}

# Function to install or update zen-browser
install_zen() {
    echo "Retrieving the latest zen-browser tar.gz file..."
    wget "https://github.com/zen-browser/desktop/releases/download/1.9b/zen.linux-x86_64.tar.xz" -O "$TAR_FILE"

    echo "Extracting files to /opt directory..."
    sudo tar -xvf "$TAR_FILE" -C /opt/
    rm "$TAR_FILE"

    echo "Creating symbolic link..."
    sudo ln -sf "$ZEN_DIR/zen" "$ZEN_BIN"

    echo "Creating desktop entry..."
    cat > ./temp << "EOF"
    
[Desktop Entry]
Name=zen-browser
StartupWMClass=zen-browser
Comment=Best browser
GenericName=Internet Messenger
Exec=/usr/bin/zen
Icon=/opt/zen/browser/chrome/icons/default/default32.png
Type=Application
Categories=Network;Internet
Path=/usr/bin
EOF
    sudo cp ./temp "$DESKTOP_FILE"
    rm ./temp

    echo "zen-browser installation/update completed."
}

# Check if zen-browser is installed and clean up if necessary
if [ -d "$ZEN_DIR" ] || [ -f "$ZEN_BIN" ]; then
    cleanup
fi

# Install or update zen-browser
install_zen
