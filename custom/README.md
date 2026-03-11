# User Customization

This directory is intended for your personal configuration overrides.

## How it works

The files in this directory are linked to your home directory using GNU Stow after the core configurations are linked.

- **`hypr/.config/hypr/custom.conf`**: Sourced at the end of the main `hyprland.conf`.
- **`kitty/.config/kitty/custom.conf`**: Included at the end of the main `kitty.conf`.
- **`fish/.config/fish/conf.d/custom.fish`**: Automatically sourced by Fish.

Feel free to add your own files and subdirectories here following the same structure. The installation script will automatically detect and link them.
