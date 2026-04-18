#!/bin/bash
# Install news-screensaver for Hyprland

set -e

echo "Installing news-screensaver..."

# dependencies
echo "Checking dependencies..."
for pkg in python-gobject gtk4-layer-shell python-feedparser python-requests; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        echo "  Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
done

# optional: pillow for faster image scaling
pip install --user Pillow 2>/dev/null || true

# install scripts
echo "Installing scripts to ~/.local/bin/..."
install -Dm755 news-screensaver "$HOME/.local/bin/news-screensaver"
install -Dm755 news-cache-updater "$HOME/.local/bin/news-cache-updater"
install -Dm755 news-toggle "$HOME/.local/bin/news-toggle"

# systemd timer for background cache updates
echo "Installing systemd timer..."
install -Dm644 news-cache.service "$HOME/.config/systemd/user/news-cache.service"
install -Dm644 news-cache.timer "$HOME/.config/systemd/user/news-cache.timer"
systemctl --user daemon-reload
systemctl --user enable --now news-cache.timer

# initial cache build
echo "Building initial news cache..."
"$HOME/.local/bin/news-cache-updater"

echo ""
echo "Done! Usage:"
echo "  news-toggle          # toggle screensaver on/off"
echo "  news-screensaver     # run directly"
echo "  news-cache-updater   # manually refresh cache"
echo ""
echo "Optional: add to Hyprland keybind:"
echo "  bindl = \$mainMod, escape, exec, ~/.local/bin/news-toggle"
echo ""
echo "Optional: add hypridle for auto-activation after 7 min idle:"
echo "  sudo pacman -S hypridle"
echo "  cp hypridle.conf.example ~/.config/hypr/hypridle.conf"
echo "  # add 'hypridle' to your hyprland startup.conf"
