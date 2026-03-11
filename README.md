# Noctrya Dotfiles

Custom configuration files managed with GNU Stow.

> [!IMPORTANT]
> These dotfiles are specifically designed for **Hyprland** and may not function correctly on other desktop environments or window managers.

## Installation

1. Clone the repository to your preferred location:
   ```bash
   git clone https://github.com/cleboost/noctrya.git
   cd noctrya
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```

## What the script does

1. **Package Installation**: Automatically detects your AUR helper (`yay` or `paru`) and installs necessary packages (`stow`, `thunar`, `kitty`, etc.), including updating `-git` packages to their latest commits.
2. **Dynamic Stow Linking**: Detects all configurations inside the `stow/` directory, removes existing conflicts in `~/.config/`, and creates symbolic links to your home directory.

## Requirements

- An Arch-based Linux distribution.
- An AUR helper (`yay` is installed automatically if not found).
