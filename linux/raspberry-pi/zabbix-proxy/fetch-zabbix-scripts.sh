#!/bin/bash

# Define the destination directory where the scripts will be placed
DEST_DIR="/usr/lib/zabbix/externalscripts"

# Define the repository URL
REPO_URL="https://github.com/MartinHajducik/jsemit.git"

# Define temporary directory for cloning
TEMP_DIR="/tmp/zabbix-scripts-repo"

# Ensure the destination directory exists
mkdir -p "$DEST_DIR"

# Clone the repository to the temporary directory (only the specific directory) using sparse-checkout
echo "Cloning repository into $TEMP_DIR..."
git clone --filter=blob:none --no-checkout "$REPO_URL" "$TEMP_DIR"

# Navigate to the temporary repository
cd "$TEMP_DIR" || { echo "Failed to navigate to $TEMP_DIR"; exit 1; }

# Enable sparse-checkout
git sparse-checkout init --cone

# Set the directory you want to checkout (in this case, `linux/raspberry-pi/zabbix-proxy/externalscripts`)
git sparse-checkout set linux/raspberry-pi/zabbix-proxy/externalscripts

# Fetch the files
git checkout

# Move all needed files from the cloned directory to the destination directory
echo "Moving scripts to $DEST_DIR..."
find linux/raspberry-pi/zabbix-proxy/externalscripts -type f -name "*.sh" -exec mv {} "$DEST_DIR" \;

# Ensure all the files in this directory are executable
echo "Making scripts executable..."
find "$DEST_DIR" -type f -name "*.sh" -exec chmod +x {} \;

# Clean up by removing the temporary cloned repository
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Confirmation
echo "Downloaded and made scripts executable in $DEST_DIR. Temporary files removed."
