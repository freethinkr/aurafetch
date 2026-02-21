#!/usr/bin/env bash
# ── AuraFetch: OS/Distro Detection ──────────────────────────

get_distro_id() {
    local os_release=""
    # Check for Termux/Android path first or fallback to standard Linux path
    if [[ -f /data/data/com.termux/files/usr/etc/os-release ]]; then
        os_release="/data/data/com.termux/files/usr/etc/os-release"
    elif [[ -f /etc/os-release ]]; then
        os_release="/etc/os-release"
    fi

    if [[ -n "$os_release" ]]; then
        local id=""
        # `|| [[ -n "$key" ]]` ensures the last line is read even without a trailing newline
        while IFS='=' read -r key val || [[ -n "$key" ]]; do
            val="${val%\"}"
            val="${val#\"}"
            val="${val//$'\r'/}"
            [[ "$key" == "ID" ]] && id="$val"
        done < "$os_release"
        
        # In case the ID is termux, we map it to android
        if [[ "$id" == "termux" ]]; then
            id="android"
        fi

        # ── Ubuntu Flavor Refinement ───────────────────────
        if [[ "$id" == "ubuntu" ]]; then
            # Check for KDE/Plasma to identify Kubuntu
            if [[ "$XDG_CURRENT_DESKTOP" == *"KDE"* || "$XDG_CURRENT_DESKTOP" == *"Plasma"* ]]; then
                id="kubuntu"
            fi
        fi
        
        echo "${id:-linux}" | tr '[:upper:]' '[:lower:]'
    else
        # Fallback to checking via uname
        if [[ "$(uname -o 2>/dev/null)" == *"Android"* || "$(uname -a 2>/dev/null)" == *"Android"* ]]; then
            echo "android"
        else
            echo "linux"
        fi
    fi
}

get_distro_name() {
    if [[ -f /etc/os-release ]]; then
        local name=""
        while IFS='=' read -r key val; do
            val="${val%\"}"
            val="${val#\"}"
            [[ "$key" == "PRETTY_NAME" ]] && name="$val"
        done < /etc/os-release
        echo "${name:-$(uname -s)}"
    else
        echo "$(uname -s) $(uname -m)"
    fi
}

# Find the right logo file for a distro
find_logo_file() {
    local distro_id="$1"
    local logo_dir="$2"
    local use_small="$3"

    local logo_file=""

    if [[ "$use_small" == "true" ]]; then
        logo_file="${logo_dir}/${distro_id}_small.txt"
        [[ -f "$logo_file" ]] && { echo "$logo_file"; return; }
    fi

    logo_file="${logo_dir}/${distro_id}.txt"
    [[ -f "$logo_file" ]] && { echo "$logo_file"; return; }

    # Try common aliases
    case "$distro_id" in
        ubuntu*)    logo_file="${logo_dir}/ubuntu.txt" ;;
        fedora*)    logo_file="${logo_dir}/fedora.txt" ;;
        opensuse*)  logo_file="${logo_dir}/opensuse.txt" ;;
        linuxmint*) logo_file="${logo_dir}/linuxmint.txt" ;;
        *)          logo_file="${logo_dir}/linux.txt" ;;
    esac

    [[ -f "$logo_file" ]] && echo "$logo_file" || echo ""
}
