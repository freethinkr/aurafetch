# 🌟 AuraFetch — The Ultimate System Info Fetcher

> **A beautifully designed, feature-rich system information tool for Linux, surpassing fastfetch & neofetch with a premium, structured box-based UI and extensive distro logo support.**

---

## 🎯 Project Vision

AuraFetch is the next-gen system fetch tool designed to look **stunning** in any terminal. Unlike basic fetch tools, AuraFetch organizes information into **structured, bordered boxes** with a clean layout, displays an elegant distro logo alongside grouped system details, and provides **more information than any other fetch tool**.

---

## 🖼️ Layout Design

```
┌──────────────────────────────────────────────────────────────────────────┐
│                            ✦ AURAFETCH ✦                                │
├─────────────────────────┬────────────────────────────────────────────────┤
│                         │  ┌─── 🖥️  SYSTEM ─────────────────────────┐    │
│     ██████████████      │  │  OS        : Arch Linux x86_64         │    │
│     ██████████████      │  │  Kernel    : 6.7.4-arch1-1             │    │
│     ████  ████████      │  │  Hostname  : aurora-pc                 │    │
│     ██      ██████      │  │  Uptime    : 3d 14h 22m                │    │
│     ██████████████      │  │  Packages  : 1284 (pacman)             │    │
│     ██████████████      │  │  Shell     : zsh 5.9.0                 │    │
│    (DISTRO ASCII ART)   │  └────────────────────────────────────────┘    │
│                         │  ┌─── 🎨  DESKTOP ────────────────────────┐    │
│                         │  │  DE        : KDE Plasma 6.0.1          │    │
│                         │  │  WM        : KWin (Wayland)            │    │
│                         │  │  Theme     : Breeze-Dark               │    │
│                         │  │  Icons     : Papirus-Dark              │    │
│                         │  │  Font      : JetBrains Mono 11         │    │
│                         │  │  Cursor    : Bibata-Modern-Classic     │    │
│                         │  │  Terminal  : kitty 0.33.1              │    │
│                         │  └────────────────────────────────────────┘    │
│                         │  ┌─── ⚙️  HARDWARE ───────────────────────┐    │
│                         │  │  CPU       : AMD Ryzen 7 5800X (16)    │    │
│                         │  │  GPU       : NVIDIA RTX 3070 Ti        │    │
│                         │  │  Memory    : 6.2 GiB / 31.2 GiB        │    │
│                         │  │  Disk      : 234G / 512G (46%)         │    │
│                         │  │  Battery   : 🔌 AC (Desktop)           │    │
│                         │  │  Resolution: 2560x1440 @ 165Hz         │    │
│                         │  └────────────────────────────────────────┘    │
│                         │  ┌─── 🌐  NETWORK ───────────────────────┐     │
│                         │  │  Local IP  : 192.168.1.42             │     │
│                         │  │  Public IP : ●●●●●●●● (hidden)        │     │
│                         │  │  Interface : wlan0 (Wi-Fi)            │     │
│                         │  └────────────────────────────────────────┘    │
├──────────────────────────────────────────────────────────────────────────┤
│  ● ● ● ● ● ● ● ●    COLOR PALETTE    ● ● ● ● ● ● ● ●                     │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Information Modules (Boxes)

AuraFetch groups information into **themed boxes**, each with an icon & title:

### Box 1: 🖥️ SYSTEM
| Field      | Source / Method                         |
|------------|-----------------------------------------|
| OS         | `/etc/os-release` → `PRETTY_NAME`       |
| Kernel     | `uname -r`                              |
| Hostname   | `hostname` / `cat /etc/hostname`        |
| Uptime     | `/proc/uptime` → formatted              |
| Packages   | Count from pacman/apt/dnf/flatpak/snap  |
| Shell      | `$SHELL --version`                      |
| Init       | PID 1 detection (systemd/openrc/runit)  |
| Locale     | `$LANG`                                 |

### Box 2: 🎨 DESKTOP
| Field      | Source / Method                         |
|------------|-----------------------------------------|
| DE         | `$XDG_CURRENT_DESKTOP` / `$DESKTOP_SESSION` |
| WM         | `wmctrl -m` / check running processes   |
| Display    | `$XDG_SESSION_TYPE` (X11/Wayland)       |
| Theme      | gsettings / kde config                  |
| Icons      | gsettings / kde config                  |
| Font       | gsettings / kde config                  |
| Cursor     | gsettings / kde config                  |
| Terminal   | `$TERM` + parent process detection      |
| Term Font  | Terminal config parsing                 |

### Box 3: ⚙️ HARDWARE
| Field      | Source / Method                         |
|------------|-----------------------------------------|
| CPU        | `/proc/cpuinfo` → model + core count    |
| GPU        | `lspci` → VGA controllers               |
| Memory     | `/proc/meminfo` → used/total            |
| Swap       | `/proc/meminfo` → swap used/total       |
| Disk       | `df -h /` → used/total/percent          |
| Battery    | `/sys/class/power_supply/`              |
| Resolution | `xrandr` / `wlr-randr` / `xdpyinfo`    |
| Monitors   | Multi-monitor detection                 |

### Box 4: 🌐 NETWORK
| Field       | Source / Method                        |
|-------------|----------------------------------------|
| Local IP    | `ip addr` / `hostname -I`             |
| Public IP   | Optional: `curl ifconfig.me`           |
| Interface   | Active interface detection             |
| MAC Address | `ip link`                              |

### Box 5: 🎵 MEDIA (optional)
| Field       | Source / Method                        |
|-------------|----------------------------------------|
| Now Playing | `playerctl metadata`                   |
| Volume      | `pactl` / `amixer`                     |

---

## 🎨 Visual Features

### Color Themes
- **Auto-detect**: Colors match the detected distro's brand colors
- **Custom themes**: User-configurable color schemes via config file
- **16-color / 256-color / Truecolor** support with fallback

### Box Borders
- **Unicode box-drawing characters**: `┌ ┐ └ ┘ │ ─ ├ ┤ ┬ ┴ ┼`
- **Rounded corners option**: `╭ ╮ ╰ ╯`
- **ASCII fallback**: `+ - | =` for limited terminals

### Color Palette Bar
- Display terminal's **16-color** palette at the bottom
- Both **foreground blocks** and **background blocks** in alternating rows

---

## 🐧 Distro Logo Support

500+ distro ASCII art logos already available in `ascii/` directory including:
- **Major distros**: Arch, Ubuntu, Fedora, Debian, Manjaro, openSUSE, NixOS, etc.
- **Small variants**: `*_small.txt` for compact display
- **Auto-detection**: Reads `/etc/os-release` to pick the right logo
- **Manual override**: `aurafetch --logo <distro>` flag
- **Logo coloring**: Uses distro-specific brand colors with `$1`/`$2` markers

---

## 🛠️ Technical Architecture

### Language: **Bash** (Shell Script)
> Bash ensures maximum portability — runs on **any Linux system** out of the box with zero dependencies.

### File Structure
```
aurafetch/
├── aurafetch              # Main script (executable)
├── ascii/                 # 500+ distro ASCII art files
│   ├── arch.txt
│   ├── ubuntu.txt
│   ├── fedora.txt
│   └── ... (500 files)
├── lib/
│   ├── detect.sh          # OS/distro detection functions
│   ├── system.sh          # System info (OS, kernel, uptime, etc.)
│   ├── desktop.sh         # Desktop env info (DE, WM, themes, etc.)
│   ├── hardware.sh        # Hardware info (CPU, GPU, RAM, disk)
│   ├── network.sh         # Network info (IP, interface, etc.)
│   ├── media.sh           # Media info (now playing, volume)
│   ├── colors.sh          # Color/theme management
│   ├── render.sh          # Box rendering & layout engine
│   └── utils.sh           # Utility functions
├── config/
│   └── aurafetch.conf     # Default configuration
├── install.sh             # Installation script
├── uninstall.sh           # Uninstallation script
├── README.md              # Documentation
├── LICENSE                # MIT License
└── objective.md           # This file
```

### Rendering Engine
The layout engine will:
1. **Measure** the ASCII logo dimensions (width × height)
2. **Build** each info box with proper borders
3. **Combine** logo + boxes side by side
4. **Apply** colors based on distro theme or user config
5. **Output** the final composed frame to stdout

---

## ⚡ CLI Flags & Options

| Flag                   | Description                                |
|------------------------|--------------------------------------------|
| `--help`               | Show help message                          |
| `--logo <distro>`      | Override auto-detected distro logo         |
| `--logo-small`         | Use small variant of the logo              |
| `--no-logo`            | Hide the logo, show info only              |
| `--color <theme>`      | Use a specific color theme                 |
| `--no-color`           | Disable all colors                         |
| `--boxes <list>`       | Choose which boxes to show (e.g. `system,hardware`) |
| `--compact`            | Compact mode (fewer details)               |
| `--json`               | Output in JSON format for scripting        |
| `--config <path>`      | Use a custom config file                   |
| `--ascii-only`         | Use ASCII-only borders (no Unicode)        |
| `--version`            | Show version                               |

---

## 📐 Config File Format (`~/.config/aurafetch/aurafetch.conf`)

```bash
# AuraFetch Configuration

# Color theme: auto | nord | dracula | gruvbox | catppuccin | solarized
THEME="auto"

# Border style: unicode | rounded | ascii | none
BORDER_STYLE="rounded"

# Which boxes to display (comma-separated)
BOXES="system,desktop,hardware,network"

# Show color palette bar at bottom
SHOW_PALETTE=true

# Logo size: normal | small
LOGO_SIZE="normal"

# Override distro detection
# LOGO_OVERRIDE="arch"

# Show public IP (requires internet)
SHOW_PUBLIC_IP=false

# Compact mode
COMPACT=false
```

---

## 🚀 Installation

### Quick Install
```bash
git clone https://github.com/your-username/aurafetch.git
cd aurafetch
chmod +x install.sh
./install.sh
```

### Manual Install
```bash
sudo cp aurafetch /usr/local/bin/
sudo cp -r ascii/ /usr/share/aurafetch/
sudo cp -r lib/ /usr/share/aurafetch/
mkdir -p ~/.config/aurafetch/
cp config/aurafetch.conf ~/.config/aurafetch/
```

---

## 🗺️ Development Roadmap

### Phase 1: Core Foundation ✦
- [ ] Main script structure with argument parsing
- [ ] OS/distro detection module
- [ ] ASCII logo loading and rendering
- [ ] Basic system info collection (OS, kernel, uptime, shell)

### Phase 2: Info Modules ✦
- [ ] Complete system info module
- [ ] Desktop environment module
- [ ] Hardware info module
- [ ] Network info module
- [ ] Media info module (optional)

### Phase 3: Rendering Engine ✦
- [ ] Box-drawing and border rendering
- [ ] Side-by-side layout (logo + boxes)
- [ ] Color theme system (auto-detect + custom themes)
- [ ] Color palette bar

### Phase 4: Configuration & CLI ✦
- [ ] Config file parsing
- [ ] CLI flag handling
- [ ] JSON output mode
- [ ] Compact mode

### Phase 5: Polish & Distribution ✦
- [ ] Install/uninstall scripts
- [ ] README with screenshots
- [ ] Man page
- [ ] AUR package / deb package
- [ ] Performance optimization

---

## 🏁 Success Criteria

- ✅ Runs on any Linux distro with bash installed (zero external deps for core)
- ✅ Displays more system info than neofetch/fastfetch
- ✅ Looks **significantly more beautiful** with structured boxes
- ✅ Auto-detects distro and applies matching logo + colors
- ✅ Renders in under 1 second on average hardware
- ✅ Fully configurable via config file and CLI flags
- ✅ Supports 500+ distro logos out of the box
