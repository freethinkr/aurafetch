#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════╗
# ║              AURAFETCH — Demo Preview                     ║
# ║   This script shows what aurafetch will look like         ║
# ╚═══════════════════════════════════════════════════════════╝

# ── Colors ──────────────────────────────────────────────────
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Foreground
BLK="\033[30m"; RED="\033[31m"; GRN="\033[32m"; YLW="\033[33m"
BLU="\033[34m"; MAG="\033[35m"; CYN="\033[36m"; WHT="\033[37m"

# Bright foreground
BBLK="\033[90m"; BRED="\033[91m"; BGRN="\033[92m"; BYLW="\033[93m"
BBLU="\033[94m"; BMAG="\033[95m"; BCYN="\033[96m"; BWHT="\033[97m"

# Background for palette
BG_BLK="\033[40m"; BG_RED="\033[41m"; BG_GRN="\033[42m"; BG_YLW="\033[43m"
BG_BLU="\033[44m"; BG_MAG="\033[45m"; BG_CYN="\033[46m"; BG_WHT="\033[47m"
BG_BBLK="\033[100m"; BG_BRED="\033[101m"; BG_BGRN="\033[102m"; BG_BYLW="\033[103m"
BG_BBLU="\033[104m"; BG_BMAG="\033[105m"; BG_BCYN="\033[106m"; BG_BWHT="\033[107m"

# ── Theme colors ────────────────────────────────────────────
ACCENT="${BCYN}"
ACCENT2="${BBLU}"
TITLE_COLOR="${BOLD}${BCYN}"
HEADER="${BOLD}${BWHT}"
LABEL="${BCYN}"
VALUE="${BWHT}"
BORDER="${BBLU}"
BORDER2="${CYN}"
DIM_BORDER="${BBLK}"
ICON_SYS="${BCYN}"
ICON_DT="${BMAG}"
ICON_HW="${BGRN}"
ICON_NET="${BYLW}"

# ── Box drawing chars (rounded) ─────────────────────────────
TL="╭" TR="╮" BL="╰" BR="╯" H="─" V="│"
TL2="┌" TR2="┐" BL2="└" BR2="┘"

# ── Collect system info ─────────────────────────────────────
get_os() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${PRETTY_NAME:-$NAME}"
    else
        echo "$(uname -s) $(uname -r)"
    fi
}

get_kernel() { uname -r; }

get_hostname() { hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown"; }

get_uptime() {
    local up
    up=$(cat /proc/uptime 2>/dev/null | cut -d. -f1)
    if [[ -n "$up" ]]; then
        local d=$((up/86400)) h=$(((up%86400)/3600)) m=$(((up%3600)/60))
        local out=""
        [[ $d -gt 0 ]] && out+="${d}d "
        [[ $h -gt 0 ]] && out+="${h}h "
        out+="${m}m"
        echo "$out"
    else
        uptime -p 2>/dev/null | sed 's/up //' || echo "unknown"
    fi
}

get_packages() {
    local total=0 managers=""
    if command -v pacman &>/dev/null; then
        local c; c=$(pacman -Qq 2>/dev/null | wc -l)
        total=$((total + c)); managers+="${c} (pacman) "
    fi
    if command -v apt &>/dev/null; then
        local c; c=$(dpkg --list 2>/dev/null | grep -c '^ii')
        total=$((total + c)); managers+="${c} (apt) "
    fi
    if command -v dnf &>/dev/null; then
        local c; c=$(dnf list installed 2>/dev/null | grep -c '.')
        total=$((total + c)); managers+="${c} (dnf) "
    fi
    if command -v flatpak &>/dev/null; then
        local c; c=$(flatpak list 2>/dev/null | wc -l)
        [[ $c -gt 0 ]] && { total=$((total + c)); managers+=", ${c} (flatpak)"; }
    fi
    if command -v snap &>/dev/null; then
        local c; c=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        [[ $c -gt 0 ]] && { total=$((total + c)); managers+=", ${c} (snap)"; }
    fi
    echo "${managers:-unknown}"
}

get_shell() {
    local sh_name
    sh_name=$(basename "$SHELL")
    local ver=""
    case "$sh_name" in
        bash) ver=$("$SHELL" --version 2>/dev/null | head -1 | grep -oP '\d+\.\d+\.\d+') ;;
        zsh)  ver=$("$SHELL" --version 2>/dev/null | grep -oP '\d+\.\d+(\.\d+)?') ;;
        fish) ver=$("$SHELL" --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+') ;;
    esac
    echo "${sh_name}${ver:+ $ver}"
}

get_de() {
    echo "${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-unknown}}"
}

get_wm() {
    if command -v wmctrl &>/dev/null; then
        wmctrl -m 2>/dev/null | head -1 | cut -d: -f2 | xargs
    else
        local wm=""
        for w in i3 sway bspwm openbox awesome herbstluftwm dwm xmonad qtile hyprland kwin mutter muffin marco; do
            pgrep -x "$w" &>/dev/null && { wm="$w"; break; }
        done
        echo "${wm:-unknown}"
    fi
}

get_display() {
    echo "${XDG_SESSION_TYPE:-unknown}"
}

get_theme() {
    if command -v gsettings &>/dev/null; then
        gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'" || echo "unknown"
    elif [[ -f ~/.config/kdeglobals ]]; then
        grep -i "^Name=" ~/.config/kdeglobals 2>/dev/null | head -1 | cut -d= -f2 || echo "unknown"
    else
        echo "unknown"
    fi
}

get_icons() {
    if command -v gsettings &>/dev/null; then
        gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'" || echo "unknown"
    else
        echo "unknown"
    fi
}

get_terminal() {
    local term=""
    local ppid_val="$$"
    for _ in 1 2 3 4 5; do
        ppid_val=$(ps -o ppid= -p "$ppid_val" 2>/dev/null | tr -d ' ')
        [[ -z "$ppid_val" ]] && break
        local pname
        pname=$(ps -o comm= -p "$ppid_val" 2>/dev/null)
        case "$pname" in
            kitty|alacritty|wezterm*|foot|konsole|gnome-terminal*|xfce4-terminal|tilix|terminator|st|urxvt|xterm|yakuake|guake|cool-retro-term)
                term="$pname"; break ;;
        esac
    done
    echo "${term:-${TERM:-unknown}}"
}

get_cpu() {
    local model
    model=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs)
    local cores
    cores=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)
    if [[ -n "$model" ]]; then
        # Shorten model name
        model=$(echo "$model" | sed 's/(R)//g;s/(TM)//g;s/CPU //g' | xargs)
        echo "${model} (${cores})"
    else
        echo "unknown"
    fi
}

get_gpu() {
    if command -v lspci &>/dev/null; then
        lspci 2>/dev/null | grep -i 'vga\|3d\|display' | head -1 | sed 's/.*: //' | cut -c1-45
    else
        echo "unknown"
    fi
}

get_memory() {
    local total used
    total=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
    local avail
    avail=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ -n "$total" && -n "$avail" ]]; then
        used=$(( (total - avail) / 1024 ))
        total=$((total / 1024))
        printf "%s MiB / %s MiB" "$used" "$total"
    else
        free -h 2>/dev/null | awk '/Mem:/{print $3 " / " $2}' || echo "unknown"
    fi
}

get_disk() {
    df -h / 2>/dev/null | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}'
}

get_resolution() {
    if command -v xrandr &>/dev/null && [[ -n "$DISPLAY" ]]; then
        xrandr 2>/dev/null | grep '\*' | head -1 | awk '{print $1}'
    elif command -v wlr-randr &>/dev/null; then
        wlr-randr 2>/dev/null | grep 'current' | head -1 | awk '{print $1}'
    else
        echo "unknown"
    fi
}

get_local_ip() {
    hostname -I 2>/dev/null | awk '{print $1}' || echo "unknown"
}

get_interface() {
    ip route 2>/dev/null | grep default | head -1 | awk '{print $5}' || echo "unknown"
}

get_init() {
    local init_name
    init_name=$(ps -p 1 -o comm= 2>/dev/null)
    echo "${init_name:-unknown}"
}

get_distro_id() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "${ID:-linux}" | tr '[:upper:]' '[:lower:]'
    else
        echo "linux"
    fi
}

# ── Load ASCII Logo ────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

load_logo() {
    local distro_id
    distro_id=$(get_distro_id)
    local logo_file="${SCRIPT_DIR}/ascii/${distro_id}.txt"

    # Fallback chain
    if [[ ! -f "$logo_file" ]]; then
        logo_file="${SCRIPT_DIR}/ascii/linux.txt"
    fi
    if [[ ! -f "$logo_file" ]]; then
        # Embedded fallback
        echo '    ___'
        echo '   (.. |'
        echo '   (<> |'
        echo '  / __  \'
        echo ' ( /  \ /|'
        echo '_/\ __)/_)'
        echo '\/-____\/'
        return
    fi

    # Process logo: replace $1/$2 with color codes
    local c1="${ACCENT}" c2="${ACCENT2}"
    while IFS= read -r line; do
        line="${line//\$1/${c1}}"
        line="${line//\$2/${c2}}"
        echo -e "${line}${RST}"
    done < "$logo_file"
}

# ── Render helpers ──────────────────────────────────────────
# Remove ANSI escape codes for width calculation
strip_ansi() {
    echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g'
}

str_len() {
    local stripped
    stripped=$(strip_ansi "$1")
    echo ${#stripped}
}

pad_right() {
    local str="$1" target_width="$2"
    local current_width
    current_width=$(str_len "$str")
    local padding=$((target_width - current_width))
    if [[ $padding -gt 0 ]]; then
        printf '%s%*s' "$str" "$padding" ""
    else
        printf '%s' "$str"
    fi
}

repeat_char() {
    local char="$1" count="$2"
    printf "%${count}s" | tr ' ' "$char"
}

# ── Build info boxes ────────────────────────────────────────
build_box() {
    local title="$1" icon_color="$2" width="$3"
    shift 3
    local lines=("$@")

    local inner=$((width - 2))
    local title_display=" ${title} "
    local title_len=${#title}
    # Add 2 for the spaces around title
    local title_total=$((title_len + 2))
    local left_bar=$(( (inner - title_total) / 2 ))
    local right_bar=$(( inner - title_total - left_bar ))

    # Top border with title
    echo -e "${icon_color}${TL}$(repeat_char "$H" "$left_bar")${BOLD}${title_display}${RST}${icon_color}$(repeat_char "$H" "$right_bar")${TR}${RST}"

    # Content lines
    for line in "${lines[@]}"; do
        local label value
        label=$(echo "$line" | cut -d'|' -f1)
        value=$(echo "$line" | cut -d'|' -f2)
        local content
        content=$(printf "  ${LABEL}%-12s${RST}${DIM_BORDER}: ${RST}${VALUE}%s${RST}" "$label" "$value")
        local content_padded
        content_padded=$(pad_right "$content" "$((width + 30))")  # extra for ANSI codes
        # We need to handle padding carefully with ANSI codes
        local visible_len
        visible_len=$(str_len "$content")
        local pad_needed=$((inner - visible_len))
        if [[ $pad_needed -lt 0 ]]; then pad_needed=0; fi
        echo -e "${icon_color}${V}${RST}${content}$(printf '%*s' "$pad_needed" "")${icon_color}${V}${RST}"
    done

    # Bottom border
    echo -e "${icon_color}${BL}$(repeat_char "$H" "$inner")${BR}${RST}"
}

# ── Main Render ─────────────────────────────────────────────
main() {
    clear

    # Collect info
    local os_info kernel_info hostname_info uptime_info packages_info shell_info
    os_info=$(get_os)
    kernel_info=$(get_kernel)
    hostname_info=$(get_hostname)
    uptime_info=$(get_uptime)
    packages_info=$(get_packages)
    shell_info=$(get_shell)

    local de_info wm_info display_info theme_info icons_info terminal_info
    de_info=$(get_de)
    wm_info=$(get_wm)
    display_info=$(get_display)
    theme_info=$(get_theme)
    icons_info=$(get_icons)
    terminal_info=$(get_terminal)

    local cpu_info gpu_info memory_info disk_info resolution_info
    cpu_info=$(get_cpu)
    gpu_info=$(get_gpu)
    memory_info=$(get_memory)
    disk_info=$(get_disk)
    resolution_info=$(get_resolution)

    local local_ip_info interface_info init_info
    local_ip_info=$(get_local_ip)
    interface_info=$(get_interface)
    init_info=$(get_init)

    # Build logo
    local logo_lines=()
    while IFS= read -r line; do
        logo_lines+=("$line")
    done < <(load_logo)

    local logo_width=0
    for line in "${logo_lines[@]}"; do
        local w
        w=$(str_len "$line")
        [[ $w -gt $logo_width ]] && logo_width=$w
    done
    logo_width=$((logo_width + 4))  # padding

    # Build boxes
    local box_width=46

    local sys_box=()
    while IFS= read -r line; do sys_box+=("$line"); done < <(
        build_box "🖥️  SYSTEM" "$ICON_SYS" "$box_width" \
            "OS|${os_info}" \
            "Kernel|${kernel_info}" \
            "Hostname|${hostname_info}" \
            "Uptime|${uptime_info}" \
            "Packages|${packages_info}" \
            "Shell|${shell_info}" \
            "Init|${init_info}"
    )

    local dt_box=()
    while IFS= read -r line; do dt_box+=("$line"); done < <(
        build_box "🎨  DESKTOP" "$ICON_DT" "$box_width" \
            "DE|${de_info}" \
            "WM|${wm_info}" \
            "Display|${display_info}" \
            "Theme|${theme_info}" \
            "Icons|${icons_info}" \
            "Terminal|${terminal_info}"
    )

    local hw_box=()
    while IFS= read -r line; do hw_box+=("$line"); done < <(
        build_box "⚙️  HARDWARE" "$ICON_HW" "$box_width" \
            "CPU|${cpu_info}" \
            "GPU|${gpu_info}" \
            "Memory|${memory_info}" \
            "Disk|${disk_info}" \
            "Resolution|${resolution_info}"
    )

    local net_box=()
    while IFS= read -r line; do net_box+=("$line"); done < <(
        build_box "🌐  NETWORK" "$ICON_NET" "$box_width" \
            "Local IP|${local_ip_info}" \
            "Interface|${interface_info}"
    )

    # Combine all right-side lines
    local right_lines=()
    for line in "${sys_box[@]}"; do right_lines+=("$line"); done
    for line in "${dt_box[@]}"; do right_lines+=("$line"); done
    for line in "${hw_box[@]}"; do right_lines+=("$line"); done
    for line in "${net_box[@]}"; do right_lines+=("$line"); done

    local total_lines=${#right_lines[@]}
    local logo_total=${#logo_lines[@]}
    local max_lines=$((total_lines > logo_total ? total_lines : logo_total))

    # Calculate logo vertical centering offset
    local logo_offset=0
    if [[ $logo_total -lt $max_lines ]]; then
        logo_offset=$(( (max_lines - logo_total) / 2 ))
    fi

    # ── Header ──────────────────────────────────────────────
    local total_width=$((logo_width + box_width + 2))
    local header_text="✦ AURAFETCH ✦"
    local header_len=${#header_text}
    local header_pad_l=$(( (total_width - header_len) / 2 ))
    local header_pad_r=$(( total_width - header_len - header_pad_l ))

    echo ""
    echo -e "  ${BORDER}${TL2}$(repeat_char "$H" "$total_width")${TR2}${RST}"
    echo -e "  ${BORDER}${V}${RST}$(printf '%*s' "$header_pad_l" "")${TITLE_COLOR}${header_text}${RST}$(printf '%*s' "$header_pad_r" "")${BORDER}${V}${RST}"
    echo -e "  ${BORDER}${TL2}$(repeat_char "$H" "$logo_width")$(repeat_char "$H" "$((box_width + 2))")${TR2}${RST}"

    # ── Body: Logo + Boxes side by side ─────────────────────
    for ((i = 0; i < max_lines; i++)); do
        # Logo column
        local logo_line=""
        local li=$((i - logo_offset))
        if [[ $li -ge 0 && $li -lt $logo_total ]]; then
            logo_line="${logo_lines[$li]}"
        fi
        local logo_padded
        logo_padded=$(pad_right "$logo_line" "$logo_width")
        local logo_visible_len
        logo_visible_len=$(str_len "$logo_line")
        local logo_pad_needed=$((logo_width - logo_visible_len))
        [[ $logo_pad_needed -lt 0 ]] && logo_pad_needed=0

        # Right column
        local right_line=""
        if [[ $i -lt $total_lines ]]; then
            right_line="${right_lines[$i]}"
        fi

        echo -e "  ${BORDER}${V}${RST} ${logo_line}$(printf '%*s' "$logo_pad_needed" "") ${BORDER}${V}${RST} ${right_line}"
    done

    # ── Footer: Color palette ───────────────────────────────
    echo -e "  ${BORDER}${TL2}$(repeat_char "$H" "$total_width")${TR2}${RST}"

    # Color palette
    local palette1=""
    local palette2=""
    for bg in "$BG_BLK" "$BG_RED" "$BG_GRN" "$BG_YLW" "$BG_BLU" "$BG_MAG" "$BG_CYN" "$BG_WHT"; do
        palette1+="${bg}   ${RST} "
    done
    for bg in "$BG_BBLK" "$BG_BRED" "$BG_BGRN" "$BG_BYLW" "$BG_BBLU" "$BG_BMAG" "$BG_BCYN" "$BG_BWHT"; do
        palette2+="${bg}   ${RST} "
    done

    local palette_text="COLOR PALETTE"
    local pal_pad=$(( (total_width - 35) / 2 ))
    echo -e "  ${BORDER}${V}${RST}$(printf '%*s' "$pal_pad" "") ${palette1}${BORDER}${V}${RST}"
    echo -e "  ${BORDER}${V}${RST}$(printf '%*s' "$pal_pad" "") ${palette2}${BORDER}${V}${RST}"
    echo -e "  ${BORDER}${BL2}$(repeat_char "$H" "$total_width")${BR2}${RST}"
    echo ""
    echo -e "  ${DIM}${BBLK}  aurafetch v0.1.0 • $(get_distro_id) • $(date '+%Y-%m-%d %H:%M')${RST}"
    echo ""
}

main "$@"
