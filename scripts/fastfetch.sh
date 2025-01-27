#!/bin/bash

# Create a temporary directory and ensure it is cleaned up on exit
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git not found, attempting to install..."
  if ! sudo apt update && sudo apt install -y git; then
    echo "Error: Failed to install Git."
    return 1
  fi
fi

# Check if CMake is installed
if ! command -v cmake &> /dev/null; then
  echo "CMake not found, attempting to install..."
  if ! sudo apt update && sudo apt install -y cmake; then
    echo "Error: Failed to install CMake."
    return 1
  fi
fi

# Clone the Fastfetch repository into the temporary directory
echo "Cloning Fastfetch repository..."
if ! git clone https://github.com/fastfetch-cli/fastfetch "$temp_dir/fastfetch"; then
  echo "Error: Failed to clone Fastfetch repository."
  return 1
fi

# Change to the Fastfetch directory
cd "$temp_dir/fastfetch" || return 1

# Run CMake to configure and build Fastfetch
echo "Configuring build with CMake..."
if ! cmake .; then
  echo "Error: CMake configuration failed."
  return 1
fi

# Run the provided run.sh script to complete the build process
echo "Running build script..."
chmod +x run.sh
if ! ./run.sh; then
  echo "Error: run.sh failed."
  return 1
fi

# The Fastfetch program should now be in the build directory
build_dir="$temp_dir/fastfetch/build"

# Check if the Fastfetch executable exists and move it to /usr/local/bin
if [ -f "$build_dir/fastfetch" ]; then
  echo "Installing Fastfetch to /usr/local/bin..."
  if ! sudo mv "$build_dir/fastfetch" /usr/local/bin/; then
    echo "Error: Failed to move Fastfetch to /usr/local/bin."
    return 1
  fi
else
  echo "Error: Fastfetch executable not found in the build directory."
  return 1
fi

echo "Fastfetch has been installed successfully!"
return 0
