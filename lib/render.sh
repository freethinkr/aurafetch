#!/usr/bin/env bash
# ── AuraFetch: Render Engine ─────────────────────────────────
# Pretty box-less layout with colored section headers,
# decorative separators, and aligned key-value pairs

# ── Load ASCII Logo ──────────────────────────────────────────
load_logo() {
    local logo_file="$1"
    local c1="${LOGO_C1}" c2="${LOGO_C2}"

    if [[ -z "$logo_file" || ! -f "$logo_file" ]]; then
        # Embedded fallback: Tux
        cat <<'TUXEOF'
        .---.
       /     \
       \.@-@./
       /`\_/`\
      //  _  \\
     | \     )|_
    /`\_`>  <_/ \
    \__/'---'\__/
TUXEOF
        return
    fi

    while IFS= read -r line; do
        line="${line//\$1/${c1}}"
        line="${line//\$2/${c2}}"
        echo -e "${line}${RST}"
    done < "$logo_file"
}

# ── Format a section header ──────────────────────────────────
# Style: colored bullet + title + fading dots
render_section_header() {
    local title="$1" icon="$2"
    local sep_len=30
    local sep=""
    for ((i=0; i<sep_len; i++)); do
        if ((i < 5)); then
            sep+="━"
        elif ((i < 10)); then
            sep+="─"
        elif ((i < 20)); then
            sep+="╌"
        else
            sep+="·"
        fi
    done
    echo -e "${T_HEADER}  ${icon}  ${title} ${T_DIM}${sep}${RST}"
}

# ── Format a key-value line ──────────────────────────────────
render_kv() {
    local key="$1" value="$2"
    local dot="${T_DOT}▸${RST}"
    printf "    ${dot} ${T_LABEL}%-12s${RST} ${T_VALUE}%s${RST}\n" "$key" "$value"
}

# ── Render the color palette ─────────────────────────────────
render_palette() {
    local row1="" row2=""
    for bg in "$BG_BLACK" "$BG_RED" "$BG_GREEN" "$BG_YELLOW" "$BG_BLUE" "$BG_MAGENTA" "$BG_CYAN" "$BG_WHITE"; do
        row1+="${bg}   ${RST} "
    done
    for bg in "$BG_BBLACK" "$BG_BRED" "$BG_BGREEN" "$BG_BYELLOW" "$BG_BBLUE" "$BG_BMAGENTA" "$BG_BCYAN" "$BG_BWHITE"; do
        row2+="${bg}   ${RST} "
    done
    echo -e "    ${row1}"
    echo -e "    ${row2}"
}

# ── Render the title bar ─────────────────────────────────────
render_title() {
    local user="$1" host="$2"
    echo -e ""
    echo -e "  ${T_TITLE}  ✦  ${BOLD}${user}${RST}${T_DIM}@${RST}${T_TITLE}${host}  ✦${RST}"
    echo -e "  ${T_DIM}  $(repeat_char '─' 40)${RST}"
    echo ""
}

# ── Build info lines array ───────────────────────────────────
# Returns lines as a single string, separated by newline
build_info_lines() {
    local -n _result=$1

    # Title
    _result+=("$(echo -e "${T_TITLE}  ✦  ${BOLD}${INFO_USER}${RST}${T_DIM}@${RST}${T_TITLE}${INFO_HOSTNAME}  ✦${RST}")")
    _result+=("$(echo -e "  ${T_DIM}  --------------------------------${RST}")")
    _result+=("")

    # ── System Section ────────────
    _result+=("$(render_section_header "SYSTEM" "◈")")
    _result+=("$(render_kv "OS" "$INFO_OS")")
    _result+=("$(render_kv "Kernel" "$INFO_KERNEL")")
    _result+=("$(render_kv "Uptime" "$INFO_UPTIME")")
    _result+=("$(render_kv "Packages" "$INFO_PACKAGES")")
    _result+=("$(render_kv "Shell" "$INFO_SHELL")")
    _result+=("$(render_kv "Init" "$INFO_INIT")")
    _result+=("")

    # ── Desktop Section ───────────
    _result+=("$(render_section_header "DESKTOP" "◇")")
    _result+=("$(render_kv "DE" "$INFO_DE")")
    _result+=("$(render_kv "WM" "$INFO_WM")")
    _result+=("$(render_kv "Display" "$INFO_DISPLAY")")
    [[ "$INFO_THEME" != "unknown" ]] && _result+=("$(render_kv "Theme" "$INFO_THEME")")
    [[ "$INFO_ICONS" != "unknown" ]] && _result+=("$(render_kv "Icons" "$INFO_ICONS")")
    _result+=("$(render_kv "Terminal" "$INFO_TERMINAL")")
    _result+=("")

    # ── Hardware Section ──────────
    _result+=("$(render_section_header "HARDWARE" "◆")")
    _result+=("$(render_kv "CPU" "$INFO_CPU")")
    _result+=("$(render_kv "GPU" "$(truncate_str "$INFO_GPU" 40)")")
    _result+=("$(render_kv "Memory" "$INFO_MEMORY")")
    _result+=("$(render_kv "Disk" "$INFO_DISK")")
    [[ "$INFO_BATTERY" != "N/A" ]] && _result+=("$(render_kv "Battery" "$INFO_BATTERY")")
    [[ "$INFO_RESOLUTION" != "unknown" ]] && _result+=("$(render_kv "Resolution" "$INFO_RESOLUTION")")
    _result+=("")

    # ── Network Section ───────────
    _result+=("$(render_section_header "NETWORK" "◎")")
    _result+=("$(render_kv "Local IP" "$INFO_LOCAL_IP")")
    _result+=("$(render_kv "Interface" "$INFO_INTERFACE")")
    [[ "$SHOW_PUBLIC_IP" == "true" && "$INFO_PUBLIC_IP" != "unknown" ]] && _result+=("$(render_kv "Public IP" "$INFO_PUBLIC_IP")")


}

# ── Main render: Logo + Info side by side ─────────────────────
render_output() {
    local logo_file="$1"
    local show_logo="$2"

    # Build info lines
    local info_lines=()
    build_info_lines info_lines

    if [[ "$show_logo" == "false" ]]; then
        # No logo mode: just print info with some left padding
        echo ""
        for line in "${info_lines[@]}"; do
            echo -e "  ${line}"
        done
        echo ""
        return
    fi

    # Load logo into array
    local logo_lines=()
    while IFS= read -r line; do
        logo_lines+=("$line")
    done < <(load_logo "$logo_file")

    # Calculate logo width
    local logo_width=0
    for line in "${logo_lines[@]}"; do
        local w
        w=$(str_len "$line")
        [[ $w -gt $logo_width ]] && logo_width=$w
    done
    logo_width=$((logo_width + 4))  # Add right padding

    local info_total=${#info_lines[@]}
    local logo_total=${#logo_lines[@]}
    local max_lines=$((info_total > logo_total ? info_total : logo_total))

    # Center logo vertically against info
    local logo_offset=0
    if [[ $logo_total -lt $max_lines ]]; then
        logo_offset=$(( (max_lines - logo_total) / 2 ))
    fi

    # Render side by side
    echo ""
    for ((i = 0; i < max_lines; i++)); do
        # Logo column
        local logo_line=""
        local li=$((i - logo_offset))
        if [[ $li -ge 0 && $li -lt $logo_total ]]; then
            logo_line="${logo_lines[$li]}"
        fi

        # Pad logo to fixed width
        local logo_visible
        logo_visible=$(str_len "$logo_line")
        local logo_pad=$((logo_width - logo_visible))
        [[ $logo_pad -lt 0 ]] && logo_pad=0

        # Info column
        local info_line=""
        if [[ $i -lt $info_total ]]; then
            info_line="${info_lines[$i]}"
        fi

        echo -e "  ${logo_line}$(printf '%*s' "$logo_pad" "")${info_line}"
    done

    echo ""
}
