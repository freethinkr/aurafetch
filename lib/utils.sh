#!/usr/bin/env bash
# ── AuraFetch: Utility Functions ─────────────────────────────

# Strip ANSI escape codes for width calculation
strip_ansi() {
    echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g'
}

# Get visible string length (without ANSI codes)
str_len() {
    local stripped
    stripped=$(strip_ansi "$1")
    echo ${#stripped}
}

# Pad string to target width
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

# Repeat a character N times
repeat_char() {
    local char="$1" count="$2"
    printf "%${count}s" | tr ' ' "$char"
}

# Truncate string to max visible length
truncate_str() {
    local str="$1" max="$2"
    if [[ ${#str} -gt $max ]]; then
        echo "${str:0:$((max-1))}…"
    else
        echo "$str"
    fi
}
