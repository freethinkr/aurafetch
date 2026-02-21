#!/usr/bin/env bash
# ── AuraFetch: System Info Module ────────────────────────────

get_os() {
    get_distro_name
}

get_kernel() {
    uname -r
}

get_arch() {
    uname -m
}

get_hostname() {
    hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo "unknown"
}

get_uptime() {
    local up
    up=$(cat /proc/uptime 2>/dev/null | cut -d. -f1)
    if [[ -n "$up" ]]; then
        local d=$((up / 86400))
        local h=$(( (up % 86400) / 3600 ))
        local m=$(( (up % 3600) / 60 ))
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
    local pkgs=()

    if command -v pacman &>/dev/null; then
        local c; c=$(pacman -Qq 2>/dev/null | wc -l)
        [[ $c -gt 0 ]] && pkgs+=("${c} (pacman)")
    fi
    if command -v dpkg &>/dev/null; then
        local c; c=$(dpkg --list 2>/dev/null | grep -c '^ii')
        [[ $c -gt 0 ]] && pkgs+=("${c} (dpkg)")
    fi
    if command -v rpm &>/dev/null && ! command -v dpkg &>/dev/null; then
        local c; c=$(rpm -qa 2>/dev/null | wc -l)
        [[ $c -gt 0 ]] && pkgs+=("${c} (rpm)")
    fi
    if command -v flatpak &>/dev/null; then
        local c; c=$(flatpak list 2>/dev/null | wc -l)
        [[ $c -gt 0 ]] && pkgs+=("${c} (flatpak)")
    fi
    if command -v snap &>/dev/null; then
        local c; c=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        [[ $c -gt 0 ]] && pkgs+=("${c} (snap)")
    fi

    if [[ ${#pkgs[@]} -gt 0 ]]; then
        local result=""
        for ((i=0; i<${#pkgs[@]}; i++)); do
            [[ $i -gt 0 ]] && result+=", "
            result+="${pkgs[$i]}"
        done
        echo "$result"
    else
        echo "unknown"
    fi
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

get_init() {
    local init_name
    init_name=$(ps -p 1 -o comm= 2>/dev/null)
    echo "${init_name:-unknown}"
}

get_user() {
    echo "${USER:-$(whoami 2>/dev/null || echo unknown)}"
}

get_locale() {
    echo "${LANG:-${LC_ALL:-unknown}}"
}
