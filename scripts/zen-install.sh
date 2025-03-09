#!/bin/sh

# Define variables
ZEN_DIR="/opt/ZenBrowser"
ZEN_BIN="/usr/bin/ZenBrowser"
DESKTOP_FILE="/usr/share/applications/zenbrowser.desktop"
TAR_FILE="zen.linux-x86_64.tar.xz"

# Function to clean up old Zen Browser installation
cleanup() {
    echo "Cleaning up old Zen Browser installation..."
    sudo rm -rf "$ZEN_DIR"
    sudo rm -f "$ZEN_BIN"
    sudo rm -f "$DESKTOP_FILE"
}

# Function to install or update Zen Browser
install_zen() {
    echo "Retrieving the latest Zen Browser tar.xz file..."
    wget "https://objects.githubusercontent.com/github-production-release-asset-2e65be/778556932/2e2151d5-23e9-4d63-82e6-a58344bd3f55?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20250308%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250308T180248Z&X-Amz-Expires=300&X-Amz-Signature=e1e0ad3a1270dd0fa2348df015ffafb89b976aaf0a2f0651430a448c65fecd8d&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dzen.linux-x86_64.tar.xz&response-content-type=application%2Foctet-stream" -O "$TAR_FILE"

    echo "Extracting files to /opt directory..."
    sudo tar -xvf "$TAR_FILE" -C /opt/
    rm "$TAR_FILE"

    # Ensure extracted folder is named correctly
    if [ -d "/opt/zen-browser" ]; then
        sudo mv /opt/zen-browser "$ZEN_DIR"
    fi

    echo "Creating symbolic link..."
    sudo ln -sf "$ZEN_DIR/ZenBrowser" "$ZEN_BIN"

    echo "Creating desktop entry..."
    cat > ./temp << "EOF"
[Desktop Entry]
Name=Zen Browser
StartupWMClass=ZenBrowser
Comment=A minimal and privacy-focused web browser.
GenericName=Web Browser
Exec=/usr/bin/ZenBrowser
Icon=/opt/ZenBrowser/icon.png
Type=Application
Categories=Network;WebBrowser;
Path=/usr/bin
EOF
    sudo cp ./temp "$DESKTOP_FILE"
    rm ./temp

    echo "Zen Browser installation/update completed."
}

# Check if Zen Browser is installed and clean up if necessary
if [ -d "$ZEN_DIR" ] || [ -f "$ZEN_BIN" ]; then
    cleanup
fi

# Install or update Zen Browser
install_zen
