#!/bin/bash

# shellcheck disable=SC2054
ALL_PKGS=("stow" "thunar" "kitty" "noctalia-shell-git" "noctalia-qs-git" "base-devel" "git" "starship" "gpu-screen-recorder" "wlsunset" "hyprshot" "hyprpicker")

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
    echo "Unable to determine home directory for user $SUDO_USER."
    exit 1
fi
FASTFETCH_CONFIG_DIR="$USER_HOME/.local/share/fastfetch"

if [ -d "$FASTFETCH_CONFIG_DIR/.git" ]; then
    echo "Fastfetch config repository already installed in $FASTFETCH_CONFIG_DIR."
elif [ -d "$FASTFETCH_CONFIG_DIR" ]; then
    echo "Directory $FASTFETCH_CONFIG_DIR already exists and is not a git repository. Skipping fastfetch config clone."
else
    echo "Installing fastfetch config in ~/.local/share..."
    sudo -u "$SUDO_USER" mkdir -p "$USER_HOME/.local/share"
    sudo -u "$SUDO_USER" git clone https://github.com/LierB/fastfetch "$FASTFETCH_CONFIG_DIR"
fi
