#!/bin/bash

# Create a temporary directory
temp_dir=$(mktemp -d)

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
  echo "Error: sudo command not found. Please run this script as root."
  return 1
fi

# Install dependencies if not already installed (CMake and Git)
for dep in cmake git; do
  if ! command -v "$dep" &> /dev/null; then
    echo "$dep not found, attempting to install..."
    if ! sudo apt update && sudo apt install -y "$dep"; then
      echo "Error: Failed to install $dep"
      return 1
    fi
  fi
done

# Clone the fastfetch repository into the temporary directory
echo "Cloning Fastfetch repository..."
if ! git clone https://github.com/fastfetch-cli/fastfetch "$temp_dir/fastfetch"; then
  echo "Error: Failed to clone Fastfetch repository."
  return 1
fi

# Change to the fastfetch directory
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

# The fastfetch program should now be in the build directory
build_dir="$temp_dir/fastfetch/build"

# Check if the fastfetch executable exists and move it to /usr/local/bin
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

# Clean up by removing the temporary directory
rm -rf "$temp_dir"

echo "Fastfetch has been installed successfully!"
return 0
