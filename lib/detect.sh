#!/usr/bin/env bash
# ── AuraFetch: OS/Distro Detection ──────────────────────────

get_distro_id() {
    if [[ -f /etc/os-release ]]; then
        local id=""
        while IFS='=' read -r key val; do
            val="${val%\"}"
            val="${val#\"}"
            [[ "$key" == "ID" ]] && id="$val"
        done < /etc/os-release
        echo "${id:-linux}" | tr '[:upper:]' '[:lower:]'
    else
        echo "linux"
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
