#!/usr/bin/env bash
# ── AuraFetch: Network Info Module ───────────────────────────

get_local_ip() {
    # Try hostname -I first
    local ip
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    [[ -n "$ip" ]] && { echo "$ip"; return; }

    # Fallback to ip command
    ip=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+')
    [[ -n "$ip" ]] && { echo "$ip"; return; }

    echo "unknown"
}

get_public_ip() {
    # Only if user has opted in (requires internet)
    local ip
    ip=$(curl -s --max-time 2 ifconfig.me 2>/dev/null)
    [[ -n "$ip" ]] && { echo "$ip"; return; }

    ip=$(curl -s --max-time 2 icanhazip.com 2>/dev/null)
    [[ -n "$ip" ]] && { echo "$ip"; return; }

    echo "unknown"
}

get_interface() {
    local iface
    iface=$(ip route 2>/dev/null | grep default | head -1 | awk '{print $5}')
    if [[ -n "$iface" ]]; then
        # Determine type
        local type="Ethernet"
        if [[ "$iface" == wl* || "$iface" == wlan* ]]; then
            type="Wi-Fi"
        elif [[ "$iface" == enp* || "$iface" == eth* ]]; then
            type="Ethernet"
        elif [[ "$iface" == lo ]]; then
            type="Loopback"
        fi
        echo "${iface} (${type})"
    else
        echo "unknown"
    fi
}
