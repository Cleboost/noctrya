#!/bin/bash

cd "$(dirname "$0")/.."

if [ ! -d "stow" ]; then
    echo "Error: 'stow' directory not found at project root."
    exit 1
fi

packages=($(ls -d stow/*/ | xargs -n 1 basename))

echo "Detecting and cleaning existing configurations for packages: ${packages[*]}"

for pkg in "${packages[@]}"; do
    if [ -d "stow/$pkg/.config" ]; then
        for subcfg in $(ls "stow/$pkg/.config"); do
            target="$HOME/.config/$subcfg"
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "Overwriting existing directory: $target"
                rm -rf "$target"
            fi
        done
    fi
    
    for item in $(ls -A "stow/$pkg"); do
        if [ "$item" != ".config" ]; then
            target="$HOME/$item"
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "Overwriting existing file/directory: $target"
                rm -rf "$target"
            fi
        fi
    done
done

echo "Linking configurations via GNU Stow..."
stow -v -R -t "$HOME" -d stow "${packages[@]}"

echo "Stow configuration completed successfully!"
