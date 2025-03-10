#!/bin/bash

set -e

echo "Installing LibreWolf..."

# Ensure system is up to date
sudo apt update

# Install extrepo if not already installed
sudo apt install -y extrepo

# Enable the LibreWolf repository
sudo extrepo enable librewolf

# Update package list and install LibreWolf
sudo apt update
sudo apt install -y librewolf

echo "LibreWolf installation complete!"
