<h1 align="center">✦ AuraFetch ✦</h1>
<p align="center">
  <b>A beautiful, feature-rich system information fetcher for Linux</b><br>
  <i>The next-gen alternative to neofetch & fastfetch</i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Shell-Bash-blue?style=for-the-badge&logo=gnu-bash" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Distros-500+-orange?style=for-the-badge" />
</p>

---

## ✨ Features

- **Pretty box-less layout** — colored section headers with elegant separators
- **Side-by-side display** — distro ASCII logo alongside system info
- **500+ distro logos** — auto-detected from your OS
- **Distro-matched colors** — theme colors change based on your distro
- **Zero dependencies** — pure bash, runs anywhere
- **Modular architecture** — easy to extend and customize
- **Multiple output modes** — terminal, JSON, no-logo, compact

## 📦 Info Displayed

| Section | Details |
|---------|---------|
| **System** | OS, Kernel, Uptime, Packages, Shell, Init |
| **Desktop** | DE, WM, Display Server, Theme, Icons, Terminal |
| **Hardware** | CPU, GPU, Memory, Disk, Battery, Resolution |
| **Network** | Local IP, Interface, Public IP (optional) |

## 🚀 Installation

```bash
git clone https://github.com/sourav/aurafetch.git
cd aurafetch
sudo ./install.sh
```

## 📖 Usage

```bash
# Auto-detect everything
aurafetch

# Use a specific distro logo
aurafetch --logo arch
aurafetch --logo fedora
aurafetch --logo manjaro

# Use a small logo variant
aurafetch --logo-small

# Hide logo, show info only
aurafetch --no-logo

# Output as JSON (for scripting)
aurafetch --json

# Show public IP
aurafetch --public-ip
```

## ⚙️ Configuration

Config file: `~/.config/aurafetch/aurafetch.conf`

```bash
# Show public IP (requires internet)
SHOW_PUBLIC_IP=false

# Logo size: normal | small
LOGO_SIZE=normal

# Override distro logo
# LOGO_OVERRIDE=arch

# Compact mode
COMPACT=false
```

## 🗑️ Uninstall

```bash
sudo ./uninstall.sh
```

## 📁 Project Structure

```
aurafetch/
├── aurafetch           # Main executable
├── lib/
│   ├── utils.sh        # String helpers
│   ├── colors.sh       # 20+ distro color themes
│   ├── detect.sh       # OS/distro detection
│   ├── system.sh       # System info module
│   ├── desktop.sh      # Desktop env module
│   ├── hardware.sh     # Hardware info module
│   ├── network.sh      # Network info module
│   └── render.sh       # Layout & render engine
├── ascii/              # 500+ distro ASCII logos
├── config/
│   └── aurafetch.conf  # Default config
├── install.sh
└── uninstall.sh
```

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit PRs.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.
