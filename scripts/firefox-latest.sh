#!/bin/sh

# Define variables
FIREFOX_DIR="/opt/firefox"
FIREFOX_BIN="/usr/local/bin/firefox"
DESKTOP_FILE="/usr/local/share/applications/firefox.desktop"
TAR_FILE="firefox.tar.xz"
TEMP_DIR="/opt/firefox-latest"

# Function to clean up old Firefox installation
cleanup() {
    echo "Cleaning up old Firefox installation..."
    sudo rm -rf "$FIREFOX_DIR"
    sudo rm -f "$FIREFOX_BIN"
    sudo rm -f "$DESKTOP_FILE"
}

# Function to install or update Firefox
install_firefox() {
    echo "Retrieving the latest Firefox tar.xz file..."
    wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" -O "$TAR_FILE"

    echo "Extracting files to a temporary directory..."
    sudo mkdir -p "$TEMP_DIR"
    sudo tar -xvf "$TAR_FILE" -C "$TEMP_DIR" --strip-components=1
    rm "$TAR_FILE"

    echo "Moving extracted files to /opt/firefox..."
    sudo rm -rf "$FIREFOX_DIR"
    sudo mv "$TEMP_DIR" "$FIREFOX_DIR"

    echo "Creating symbolic link in /usr/local/bin..."
    sudo ln -sf "$FIREFOX_DIR/firefox" "$FIREFOX_BIN"

    echo "Downloading official Firefox desktop entry..."
    sudo wget "https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop" -P /usr/local/share/applications

    echo "Firefox installation/update completed."
}

# Check if Firefox is installed and clean up if necessary
if [ -d "$FIREFOX_DIR" ] || [ -f "$FIREFOX_BIN" ]; then
    cleanup
fi

# Install or update Firefox
install_firefox
