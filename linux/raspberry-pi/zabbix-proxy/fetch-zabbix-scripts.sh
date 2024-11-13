#!/bin/bash

# Define the destination directory where the scripts will be placed
DEST_DIR="/usr/lib/zabbix/externalscripts"

# Define the repository URL
REPO_URL="https://github.com/MartinHajducik/jsemit.git"

# Ensure the destination directory is empty before cloning
if [ -d "$DEST_DIR" ]; then
  echo "Cleaning up old repository clone in $DEST_DIR"
  rm -rf "$DEST_DIR"
fi

# Clone the repository (only the specific directory) using sparse-checkout
echo "Cloning repository..."
git clone --filter=blob:none --no-checkout "$REPO_URL" "$DEST_DIR"

# Navigate to the repository
cd "$DEST_DIR" || { echo "Failed to navigate to $DEST_DIR"; exit 1; }

# Enable sparse-checkout
git sparse-checkout init --cone

# Set the directory you want to checkout (in this case, `linux/raspberry-pi/zabbix-proxy/externalscripts`)
git sparse-checkout set linux/raspberry-pi/zabbix-proxy/externalscripts

# Fetch the files
git checkout

# Ensure all the files in this directory are executable
echo "Making scripts executable..."
find . -type f -name "*.sh" -exec chmod +x {} \;

# Confirmation
echo "Downloaded and made scripts executable in $DEST_DIR."


