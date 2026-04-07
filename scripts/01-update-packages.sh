#!/bin/bash

# shellcheck disable=SC2054
ALL_PKGS=("stow" "thunar" "kitty" "noctalia-shell-git" "noctalia-qs-git" "base-devel" "git" "starship" "gpu-screen-recorder" "wlsunset" "hyprshot" "hyprpicker")

if [ -z "$SUDO_USER" ]; then
    echo "Error: SUDO_USER is not set. Please run this script via sudo from a regular user account."
    exit 1
fi

if command -v yay &> /dev/null; then
    HELPER="yay"
elif command -v paru &> /dev/null; then
    HELPER="paru"
else
    echo "No AUR helper detected. Installing yay-bin..."
    pacman -Sy --needed --noconfirm base-devel git
    temp_dir=$(mktemp -d)
    chown "$SUDO_USER:$SUDO_USER" "$temp_dir"
    sudo -u "$SUDO_USER" bash -c "cd $temp_dir && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm"
    rm -rf "$temp_dir"
    HELPER="yay"
fi

echo "Checking for updates and installing missing packages via $HELPER..."

sudo -u "$SUDO_USER" "$HELPER" -Syu --needed --devel --noconfirm --sudoloop "${ALL_PKGS[@]}"

if [ $? -eq 0 ]; then
    echo "All packages are up to date."
else
    echo "Attempting direct installation..."
    sudo -u "$SUDO_USER" "$HELPER" -S --needed --devel --noconfirm "${ALL_PKGS[@]}"
fi

USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
if [ -z "$USER_HOME" ]; then
    echo "Error: Unable to determine home directory for user: $SUDO_USER. Please ensure the user exists and has a valid home directory."
    exit 1
fi
FASTFETCH_CONFIG_DIR="$USER_HOME/.local/share/fastfetch"

echo "Installing fastfetch config in ~/.local/share..."
sudo -u "$SUDO_USER" mkdir -p "$USER_HOME/.local/share"

if [ -d "$FASTFETCH_CONFIG_DIR" ]; then
    echo "Warning: existing fastfetch config found in $FASTFETCH_CONFIG_DIR and will be replaced without backup."
    if ! sudo -u "$SUDO_USER" rm -rf "$FASTFETCH_CONFIG_DIR"; then
        echo "Error: Failed to remove existing fastfetch directory: $FASTFETCH_CONFIG_DIR."
        exit 1
    fi
fi

if ! sudo -u "$SUDO_USER" git clone https://github.com/LierB/fastfetch "$FASTFETCH_CONFIG_DIR"; then
    echo "Error: Failed to clone fastfetch config into $FASTFETCH_CONFIG_DIR."
    exit 1
fi
