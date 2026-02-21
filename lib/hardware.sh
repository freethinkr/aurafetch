#!/usr/bin/env bash
# ── AuraFetch: Hardware Info Module ──────────────────────────

get_cpu() {
    local model
    model=$(grep -m1 'model name' /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs)
    local cores
    cores=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)

    if [[ -n "$model" ]]; then
        # Clean up the model name
        model=$(echo "$model" | sed 's/(R)//g;s/(TM)//g;s/CPU //g;s/  */ /g' | xargs)
        echo "${model} (${cores})"
    else
        echo "unknown"
    fi
}


get_gpu() {
    if command -v lspci &>/dev/null; then
        local gpu
        gpu=$(lspci 2>/dev/null | grep -i 'vga\|3d\|display' | head -1 | sed 's/.*: //')
        if [[ -n "$gpu" ]]; then
            # Shorten common GPU names
            gpu=$(echo "$gpu" | sed 's/Corporation //;s/\[.*\]//;s/  */ /g' | xargs)
            echo "$(echo "${gpu}" | cut -c1-50)"
            return
        fi
    fi

    # Fallback: try /sys
    if [[ -d /sys/class/drm ]]; then
        for card in /sys/class/drm/card*/device/vendor; do
            [[ -f "$card" ]] && { cat "$card" 2>/dev/null; return; }
        done
    fi

    echo "unknown"
}

get_memory() {
    local total avail
    total=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
    avail=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')

    if [[ -n "$total" && -n "$avail" ]]; then
        local used_kb=$(( total - avail ))
        local total_mb=$((total / 1024))
        local used_mb=$((used_kb / 1024))

        if [[ $total_mb -gt 1024 ]]; then
            # Show in GiB with one decimal using pure bash
            local used_gib_int=$((used_mb / 1024))
            local used_gib_dec=$(( (used_mb % 1024) * 10 / 1024 ))
            local total_gib_int=$((total_mb / 1024))
            local total_gib_dec=$(( (total_mb % 1024) * 10 / 1024 ))
            printf "%s.%s GiB / %s.%s GiB" "$used_gib_int" "$used_gib_dec" "$total_gib_int" "$total_gib_dec"
        else
            printf "%s MiB / %s MiB" "$used_mb" "$total_mb"
        fi
    else
        free -h 2>/dev/null | awk '/Mem:/{print $3 " / " $2}' || echo "unknown"
    fi
}


get_memory_percent() {
    local total avail
    total=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
    avail=$(grep MemAvailable /proc/meminfo 2>/dev/null | awk '{print $2}')

    if [[ -n "$total" && -n "$avail" && "$total" -gt 0 ]]; then
        echo "$(( (total - avail) * 100 / total ))%"
    else
        echo ""
    fi
}

get_swap() {
    local total used
    total=$(grep SwapTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
    local free
    free=$(grep SwapFree /proc/meminfo 2>/dev/null | awk '{print $2}')

    if [[ -n "$total" && "$total" -gt 0 && -n "$free" ]]; then
        used=$(( (total - free) / 1024 ))
        total=$((total / 1024))
        printf "%s MiB / %s MiB" "$used" "$total"
    else
        echo "N/A"
    fi
}

get_disk() {
    df -h / 2>/dev/null | awk 'NR==2{printf "%s / %s (%s)", $3, $2, $5}'
}

get_battery() {
    local bat_path="/sys/class/power_supply"
    local bat=""

    for b in "${bat_path}"/BAT*; do
        if [[ -d "$b" ]]; then
            local cap status
            cap=$(cat "$b/capacity" 2>/dev/null)
            status=$(cat "$b/status" 2>/dev/null)

            if [[ -n "$cap" ]]; then
                local icon="🔋"
                case "$status" in
                    Charging)     icon="⚡" ;;
                    Discharging)  icon="🔋" ;;
                    Full)         icon="✅" ;;
                    "Not charging") icon="🔌" ;;
                esac
                bat="${icon} ${cap}% (${status})"
                break
            fi
        fi
    done

    if [[ -z "$bat" ]]; then
        echo "N/A"
    else
        echo "$bat"
    fi
}

get_resolution() {
    # Try xrandr (X11)
    if command -v xrandr &>/dev/null && [[ -n "$DISPLAY" ]]; then
        local res
        res=$(xrandr 2>/dev/null | grep '\*' | head -1 | awk '{print $1}')
        [[ -n "$res" ]] && { echo "$res"; return; }
    fi

    # Try wlr-randr (Wayland)
    if command -v wlr-randr &>/dev/null; then
        local res
        res=$(wlr-randr 2>/dev/null | grep 'current' | head -1 | awk '{print $1}')
        [[ -n "$res" ]] && { echo "$res"; return; }
    fi

    # Try xdpyinfo
    if command -v xdpyinfo &>/dev/null && [[ -n "$DISPLAY" ]]; then
        local res
        res=$(xdpyinfo 2>/dev/null | grep dimensions | head -1 | awk '{print $2}')
        [[ -n "$res" ]] && { echo "$res"; return; }
    fi

    # Try KDE Wayland
    if command -v kscreen-doctor &>/dev/null; then
        local res
        res=$(kscreen-doctor --outputs 2>/dev/null | grep -oP '\d+x\d+@' | head -1 | tr -d '@')
        [[ -n "$res" ]] && { echo "$res"; return; }
    fi

    echo "unknown"
}
