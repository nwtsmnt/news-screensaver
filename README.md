# news-screensaver

A news screensaver for Hyprland (Wayland) that displays live tech and cyber security news as an interactive overlay on your desktop wallpaper.

![screenshot](screenshot.png)

## Features

- **Live news cards** from Cloudflare, The Register, Hacker News, BBC London, Dark Reading, Krebs on Security, and Ars Technica
- **Wallpaper background** with dark tint overlay -- your desktop wallpaper shows through
- **Click to read** -- cards expand in-place to show full article text with scrollable body
- **4x4 mini-grid** in the corner shows extra headlines with thumbnails
- **Open in browser** -- click to open the full article in your default browser
- **Slide-in animation** from top with staggered card fade-in
- **Drag up to dismiss** with rubber-band physics
- **Alt+Escape toggle** -- press once to open, press again to close
- **7-minute idle trigger** via hypridle -- appears automatically when idle
- **Background cache system** -- articles and images cached to disk, updates every 30 minutes via systemd timer
- **Instant launch** -- loads from cache with zero network delay
- **Smart article sorting** -- articles with readable text shown as main cards, browser-only articles go to the mini-grid
- **Auto-refresh** -- silently updates content if open for 30+ minutes
- **Cache age indicator** -- shows when news was last updated

## Requirements

- Arch Linux (or any distro with the packages below)
- Hyprland
- Python 3
- GTK4
- gtk4-layer-shell
- python-gobject
- python-feedparser
- python-requests

### Optional

- hypridle (for automatic idle activation)
- python-pillow (for faster image scaling in the cache updater)

## Install

```bash
git clone https://github.com/new-testament/news-screensaver.git
cd news-screensaver
./install.sh
```

## Usage

### Manual toggle

```bash
news-toggle
```

### Hyprland keybind

Add to your Hyprland binds config:

```
bindl = $mainMod, escape, exec, ~/.local/bin/news-toggle
```

### Auto-activate on idle

Install hypridle and copy the example config:

```bash
sudo pacman -S hypridle
cp hypridle.conf.example ~/.config/hypr/hypridle.conf
```

Add `hypridle` to your Hyprland `startup.conf`:

```
exec-once = hypridle
```

The screensaver will appear after 7 minutes of inactivity.

### Controls

| Action | Effect |
|--------|--------|
| Click a card | Expand to read the article |
| Esc / Enter | Go back to news grid (or close if on main screen) |
| Drag up | Dismiss the screensaver |
| Alt+Escape | Toggle on/off |
| Click "open in browser" | Opens article in browser and closes screensaver |
| Click "refresh" | Force-fetch fresh news |

## How it works

1. **news-cache-updater** runs every 30 minutes via systemd timer, fetching RSS feeds, downloading and pre-scaling images, and pre-fetching article text
2. **news-screensaver** reads the cached JSON and images on launch -- no network calls needed
3. The overlay uses GTK4 + gtk4-layer-shell to sit on top of everything as a Wayland layer surface
4. Your wallpaper is detected from `~/.cache/wal/wal` (pywal) or `~/Pictures/Wallpapers/` and displayed as the background with a dark tint

## RSS Sources

| Source | Feed |
|--------|------|
| Cloudflare Blog | blog.cloudflare.com/rss |
| The Register | theregister.com/headlines.atom |
| Hacker News | hnrss.org/frontpage |
| BBC London | feeds.bbci.co.uk/news/england/london |
| Dark Reading | darkreading.com/rss.xml |
| Krebs on Security | krebsonsecurity.com/feed |
| Ars Technica | feeds.arstechnica.com |

Edit the `RSS_FEEDS` list in both `news-screensaver` and `news-cache-updater` to customize sources.

## File locations

| File | Purpose |
|------|---------|
| `~/.local/bin/news-screensaver` | Main screensaver app |
| `~/.local/bin/news-cache-updater` | Background cache updater |
| `~/.local/bin/news-toggle` | Toggle script for keybind |
| `~/.cache/news-screensaver/cache.json` | Cached articles |
| `~/.cache/news-screensaver/images/` | Cached images |
| `~/.cache/news-screensaver/wallpaper-bg.jpg` | Scaled wallpaper cache |
| `~/.config/systemd/user/news-cache.timer` | Systemd timer (30 min) |

## License

MIT
