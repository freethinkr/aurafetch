#!/usr/bin/env bash
# ── AuraFetch: ASCII Text Generator ────────────────────────
# Simple 3-high block font for zero-dependency ASCII art

render_ascii_text() {
    local input=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local -n _output=$2
    local line1="" line2="" line3=""

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            A) line1+=" █▀█ "; line2+=" █▀█ "; line3+=" ▀ ▀ " ;;
            B) line1+=" █▀▄ "; line2+=" █▀▄ "; line3+=" ▀▀  " ;;
            C) line1+=" █▀▀ "; line2+=" █ ▄ "; line3+=" ▀▀▀ " ;;
            D) line1+=" █▀▄ "; line2+=" █ █ "; line3+=" ▀▀  " ;;
            E) line1+=" █▀▀ "; line2+=" █▀▀ "; line3+=" ▀▀▀ " ;;
            F) line1+=" █▀▀ "; line2+=" █▀▀ "; line3+=" ▀   " ;;
            G) line1+=" █▀▀ "; line2+=" █ █ "; line3+=" ▀▀▀ " ;;
            H) line1+=" █ █ "; line2+=" █▀█ "; line3+=" ▀ ▀ " ;;
            I) line1+="  █  "; line2+="  █  "; line3+="  ▀  " ;;
            J) line1+="   █ "; line2+=" █ █ "; line3+=" ▀▀  " ;;
            K) line1+=" █ ▄ "; line2+=" █▀  "; line3+=" ▀ ▀ " ;;
            L) line1+=" █   "; line2+=" █   "; line3+=" ▀▀▀ " ;;
            M) line1+=" █▄█ "; line2+=" █ █ "; line3+=" ▀ ▀ " ;;
            N) line1+=" █▄█ "; line2+=" █ █ "; line3+=" ▀ ▀ " ;;
            O) line1+=" █▀█ "; line2+=" █ █ "; line3+=" ▀▀▀ " ;;
            P) line1+=" █▀▀ "; line2+=" █▀▀ "; line3+=" ▀   " ;;
            Q) line1+=" █▀█ "; line2+=" █ █ "; line3+=" ▀▀█ " ;;
            R) line1+=" █▀▄ "; line2+=" █▀▄ "; line3+=" ▀ ▀ " ;;
            S) line1+=" █▀▀ "; line2+=" ▀▀█ "; line3+=" ▀▀▀ " ;;
            T) line1+=" ▀█▀ "; line2+="  █  "; line3+="  ▀  " ;;
            U) line1+=" █ █ "; line2+=" █ █ "; line3+=" ▀▀▀ " ;;
            V) line1+=" █ █ "; line2+=" █ █ "; line3+="  ▀  " ;;
            W) line1+=" █ █ "; line2+=" █▄█ "; line3+=" ▀ ▀ " ;;
            X) line1+=" █ █ "; line2+="  █  "; line3+=" ▀ ▀ " ;;
            Y) line1+=" █ █ "; line2+="  █  "; line3+="  ▀  " ;;
            Z) line1+=" ▀▀█ "; line2+="  █  "; line3+=" █▀▀ " ;;
            " ") line1+="     "; line2+="     "; line3+="     " ;;
            1) line1+=" ▄█  "; line2+="  █  "; line3+=" ▄█▄ " ;;
            2) line1+=" ▀▀█ "; line2+=" █▀▀ "; line3+=" ▀▀▀ " ;;
            3) line1+=" ▀▀█ "; line2+="  ▀█ "; line3+=" ▀▀▀ " ;;
            4) line1+=" █ █ "; line2+=" ▀▀█ "; line3+="   █ " ;;
            5) line1+=" █▀▀ "; line2+=" ▀▀█ "; line3+=" ▀▀▀ " ;;
            6) line1+=" █▀▀ "; line2+=" █▀█ "; line3+=" ▀▀▀ " ;;
            7) line1+=" ▀▀█ "; line2+="   █ "; line3+="   ▀ " ;;
            8) line1+=" █▀█ "; line2+=" █▀█ "; line3+=" ▀▀▀ " ;;
            9) line1+=" █▀█ "; line2+=" ▀▀█ "; line3+=" ▀▀▀ " ;;
            0) line1+=" █▀█ "; line2+=" █ █ "; line3+=" ▀▀▀ " ;;
            "@") line1+=" ▄▀▀ "; line2+=" █ ▀ "; line3+=" ▀▀▀ " ;;
            "-") line1+="     "; line2+=" ▀▀▀ "; line3+="     " ;;
            "_") line1+="     "; line2+="     "; line3+=" ▀▀▀ " ;;
            ".") line1+="     "; line2+="     "; line3+="  ▀  " ;;
            *) line1+="  ▄  "; line2+=" ▄█▄ "; line3+="  ▀  " ;;
        esac
    done

    _output+=("${line1}")
    _output+=("${line2}")
    _output+=("${line3}")
}
