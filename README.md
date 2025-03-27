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

| Component     | Purpose                          |
|---------------|----------------------------------|
| `bspwm`       | Tiling window manager            |
| `sxhkd`       | Hotkey daemon                    |
| `picom`       | Compositor for transparency      |
| `rofi`        | Application launcher             |
| `dunst`       | Notifications                    |
| `feh`         | Wallpaper handler                |
| `wezterm`     | Terminal emulator (default)      |
| `thunar`      | File manager                     |
| `nala`        | Better apt frontend              |
| `pipewire`    | Audio handling                   |
| `pulsemixer`  | CLI audio control                |
| `xfce4-power-manager` | Power management         |
| `flameshot`   | Screenshot utility               |
| `micro`       | Terminal text editor             |
| `geany`       | Lightweight IDE + plugins        |
| `redshift`    | Night light                      |
| `qimgv`       | Lightweight image viewer         |

Also includes utilities like `ripgrep`, `fzf`, `ranger`, `unzip`, and more.

---

## 🎨 Appearance & Theming

- Minimal theme with custom wallpapers
- Polybar, dunst, rofi, and GTK themes preconfigured
- Wallpapers stored in `~/.config/bspwm/wallpaper`
- Autostart handled by `bspwmrc`
  > 💡 _Special thanks to [vinceliuice](https://github.com/vinceliuice) for creating these excellent GTK and icon themes._

---

## 🎹 Keybindings

Configured via `~/.config/sxhkd/sxhkdrc`.

| Key Combo       | Action                     |
|------------------|----------------------------|
| `Super + Enter`  | Launch terminal            |
| `Super + Space`      | Launch rofi                |
| `Super + Q`      | Close window               |
| `Super + H`| Help with Keybindings |
| `Super + Shift + R` | Restart bspwm           |

---

## 🧩 Optional Scripts

This script supports optional binary installs via your personal scripts:

- `~/.config/suckless/scripts/firefox-latest.sh`
- `~/.config/suckless/scripts/zen-install.sh`
- `~/.config/suckless/scripts/discord.sh`

---

## 📁 Dotfiles Installed

~/.config/bspwm/
├── bspwmrc                # Goes directly here
├── sxhkd/
│   └── sxhkdrc
├── polybar/
│   ├── launch.sh
│   └── config.ini
├── dunst/
│   └── dunstrc
├── rofi/
│   ├── config.rasi
│   └── theme.rasi
├── scripts/
│   ├── changevolume
│   ├── autoresize.sh
│   ├── redshift-on
│   └── ...
├── wallpaper/
│   └── many choices


