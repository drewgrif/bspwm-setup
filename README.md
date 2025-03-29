# 🪟 bspwm-setup

A minimal but functional BSPWM rice script for Debian-based systems.  
Installs all core packages, window manager configs, and themes — ready to go out of the box.

> Part of the [JustAGuy Linux](https://github.com/drewgrif) window manager collection.

---

## 🚀 Installation

```bash
git clone https://github.com/drewgrif/bspwm-setup.git
cd bspwm-setup
chmod +x install.sh
./install.sh
```

This script assumes a fresh Debian or Debian-based install with sudo access.

---

## 📦 What It Installs

| Component             | Purpose                          |
|------------------------|----------------------------------|
| `bspwm`               | Tiling window manager            |
| `sxhkd`               | Hotkey daemon                    |
| `picom` `(FT-Labs)`   | Compositor for transparency      |
| `polybar`             | Status bar                       |
| `rofi`                | Application launcher             |
| `dunst`               | Notifications                    |
| `wezterm`             | Terminal emulator (default)      |
| `firefox-esr`         | Default web browser              |
| `geany` + plugins     | Lightweight IDE                  |
| `thunar` + plugins    | File manager                     |
| `nala`                | Better apt frontend              |
| `pipewire`            | Audio handling                   |
| `flameshot`,          | Screenshot tools                 |
| `micro`               | Terminal text editor             |
| `redshift`            | Night light                      |
| `qimgv`               | Lightweight image viewer         |
| `fzf`, etc.           | Utilities & enhancements         |

> 📄 _Need help with Geany? See the full guide at [justaguylinux.com/documentation/software/geany](https://justaguylinux.com/documentation/software/geany)_

---

## 🎨 Appearance & Theming

- Minimal theme with custom wallpapers
- Polybar, dunst, rofi, and GTK themes preconfigured
- Wallpapers stored in `~/.config/bspwm/wallpaper`
- GTK Theme: [Orchis](https://github.com/vinceliuice/Orchis-theme)
- Icon Theme: [Colloid](https://github.com/vinceliuice/Colloid-icon-theme)

> 💡 _Special thanks to [vinceliuice](https://github.com/vinceliuice) for the excellent GTK and icon themes._

---

## 🔑 Keybindings Overview

| Key Combo              | Action                                |
|------------------------|----------------------------------------|
| `Super + Enter`        | Launch terminal                        |
| `Super + Space`        | Launch rofi                            |
| `Super + Q`            | Close focused window                   |
| `Super + H`            | Help via keybind viewer                |
| `Super + Shift + R`    | Restart bspwm                          |
| `Super + 1–=`          | Switch to workspace (desktop)          |
| `Super + Shift + 1–=`  | Move window to workspace (desktop)     |

Keybindings are configured via:

- `~/.config/sxhkd/sxhkdrc`
- `~/.config/bspwm/scripts/help` (run manually or with `Super + H`)

---

## 📂 Configuration Files

```
~/.config/bspwm/
├── bspwmrc                # Main bspwm config
├── sxhkd/
│   └── sxhkdrc            # Keybinding configuration
├── polybar/
│   ├── config.ini
│   └── launch.sh
├── dunst/
│   └── dunstrc
├── rofi/
│   ├── config.rasi
│   └── theme.rasi
├── scripts/
│   ├── changevolume
│   ├── autoresize.sh
│   ├── redshift-on
│   ├── help
├── wallpaper/
│   └── (wallpaper images)
```

---

## 🧩 Optional Scripts

If the following scripts are present, they’ll be executed for binary installs:

- `~/.config/suckless/scripts/firefox-latest.sh`
- `~/.config/suckless/scripts/zen-install.sh`
- `~/.config/suckless/scripts/discord.sh`

These allow you to use alternate versions of Firefox, Discord, and Zen Browser.

---

## 📺 Watch on YouTube

Want to see how it looks and works?  
🎥 Check out [JustAGuy Linux on YouTube](https://www.youtube.com/@JustAGuyLinux)

---

All three READMEs are now consistent, sharp, and packed with everything a user needs. Let me know if you'd like a badge set next (`Made for Debian`, `MIT License`, etc.) or compressed versions for GitHub summary previews!
