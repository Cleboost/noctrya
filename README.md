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

## Customization

You can add your own personal settings without modifying the core files by using the `custom/` directory:

- **Hyprland**: Add settings to `custom/hypr/.config/hypr/custom.conf`
- **Kitty**: Add settings to `custom/kitty/.config/kitty/custom.conf`
- **Fish**: Add scripts or aliases to `custom/fish/.config/fish/conf.d/custom.fish`

These files are sourced automatically and are tracked by Git as templates, but you can safely add your own local overrides.

## What the script does

1. **Package Installation**: Automatically detects your AUR helper (`yay` or `paru`) and installs necessary packages (`stow`, `thunar`, `kitty`, etc.), including updating `-git` packages to their latest commits.
   It also installs the fastfetch config by cloning `https://github.com/LierB/fastfetch` into `~/.local/share/fastfetch` (existing directory is replaced without backup to support reruns/update mode).
2. **Dynamic Stow Linking**: Detects all configurations inside the `stow/` and `custom/` directories, removes existing conflicts in `~/.config/`, and creates symbolic links to your home directory.

## Requirements

- An Arch-based Linux distribution.
- An AUR helper (`yay` is installed automatically if not found).
