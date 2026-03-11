#!/bin/bash

echo "Checking sudo privileges for installation..."
if ! sudo -v; then
    echo "Administrator access is required to install packages."
    exit 1
fi

while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Starting installation steps..."

chmod +x scripts/*.sh

echo "--- Step 1/2: Package Installation ---"
sudo ./scripts/01-update-packages.sh
if [ $? -ne 0 ]; then
    echo "Step 1 failed. Aborting installation."
    exit 1
fi

echo "--- Step 2/2: Linking configuration files with Stow ---"
./scripts/02-stow-configs.sh
if [ $? -ne 0 ]; then
    echo "Step 2 failed. Aborting installation."
    exit 1
fi

echo "Installation completed successfully!"
