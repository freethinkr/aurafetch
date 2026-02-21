#!/usr/bin/env bash
# ── AuraFetch: ASCII Text Generator ────────────────────────
# 4-line line-art font for zero-dependency ASCII art

render_ascii_text() {
    local input=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local -n _output=$2
    local line1="" line2="" line3="" line4=""

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            A) line1+="   ▄▄▄   "; line2+="  █   █  "; line3+="  █▀▀▀█  "; line4+="  ▀   ▀  " ;;
            B) line1+="  ██▀▀▄  "; line2+="  ██▀▀▄  "; line3+="  ██▄▄▀  "; line4+="  ▀▀▀▀   " ;;
            C) line1+="   ▄▀▀▀  "; line2+="  █      "; line3+="  █▄▄▄▀  "; line4+="   ▀▀▀   " ;;
            D) line1+="  ██▀▀▄  "; line2+="  ██  █  "; line3+="  ██▄▄▀  "; line4+="  ▀▀▀▀   " ;;
            E) line1+="  █████  "; line2+="  ██▀▀▀  "; line3+="  ██▄▄▄  "; line4+="  ▀▀▀▀▀  " ;;
            F) line1+="  █████  "; line2+="  ██▀▀▀  "; line3+="  ██     "; line4+="  ▀▀     " ;;
            G) line1+="   ▄▀▀▀  "; line2+="  █  ▄▄  "; line3+="  █▄▄▄█  "; line4+="   ▀▀▀   " ;;
            H) line1+="  ██  ██ "; line2+="  ██▀▀██ "; line3+="  ██  ██ "; line4+="  ▀▀  ▀▀ " ;;
            I) line1+="   ███   "; line2+="    █    "; line3+="    █    "; line4+="   ███   " ;;
            J) line1+="     ███ "; line2+="      █  "; line3+="  █   █  "; line4+="   ▀▀▀   " ;;
            K) line1+="  ██  █  "; line2+="  ██▀▀   "; line3+="  ██  █  "; line4+="  ▀▀  ▀  " ;;
            L) line1+="  ██     "; line2+="  ██     "; line3+="  ██▄▄▄  "; line4+="  ▀▀▀▀▀  " ;;
            M) line1+="  █ ▄ █  "; line2+="  █▀ ▀█  "; line3+="  █   █  "; line4+="  ▀   ▀  " ;;
            N) line1+="  █▄  █  "; line2+="  █ █ █  "; line3+="  █  ▀█  "; line4+="  ▀   ▀  " ;;
            O) line1+="   ▄▀▀▀▄ "; line2+="  █     █"; line3+="   ▀▄▄▄▀ "; line4+="    ▀▀▀  " ;;
            P) line1+="  ██▀▀▄  "; line2+="  ██▀▀▀  "; line3+="  ██     "; line4+="  ▀▀     " ;;
            Q) line1+="   ▄▀▀▀▄ "; line2+="  █     █"; line3+="   ▀▄▄▀▀▄"; line4+="    ▀▀▀ ▀" ;;
            R) line1+="  ██▀▀▄  "; line2+="  ██▀▀▀  "; line3+="  ██  █  "; line4+="  ▀▀  ▀  " ;;
            S) line1+="   ▄▀▀▀  "; line2+="   ▀▀▀▄  "; line3+="  ▀▀▀▀   "; line4+="   ▀▀▀   " ;;
            T) line1+="  █████  "; line2+="    █    "; line3+="    █    "; line4+="    ▀    " ;;
            U) line1+="  ██  ██ "; line2+="  ██  ██ "; line3+="  ▀▀▄▄▀▀ "; line4+="    ▀▀   " ;;
            V) line1+="  ██  ██ "; line2+="  ▀█  █▀ "; line3+="   ▀▄▄▀  "; line4+="    ▀▀   " ;;
            W) line1+="  █   █  "; line2+="  █ █ █  "; line3+="  ▀▄▀▄▀  "; line4+="   ▀ ▀   " ;;
            X) line1+="  ██  ██ "; line2+="   ▀██▀  "; line3+="   ▄██▄  "; line4+="  ██  ██ " ;;
            Y) line1+="  ██  ██ "; line2+="   ▀██▀  "; line3+="    ██   "; line4+="    ▀▀   " ;;
            Z) line1+="  █████  "; line2+="    ▄█▀  "; line3+="   █▄▄▄▄ "; line4+="  ▀▀▀▀▀  " ;;
            1) line1+="   ▄█    "; line2+="    █    "; line3+="    █    "; line4+="   ▄█▄   " ;;
            2) line1+="   ▄▀▀▀▄ "; line2+="      ▄▀ "; line3+="    ▄▀   "; line4+="   █▄▄▄▄ " ;;
            3) line1+="   ▀▀▀▀▄ "; line2+="     ▄▀  "; line3+="      ▀▄ "; line4+="   ▀▀▀▀  " ;;
            4) line1+="   █  █  "; line2+="   █▄▄█▄ "; line3+="      █  "; line4+="      ▀  " ;;
            5) line1+="   █▀▀▀▀ "; line2+="   ▀▀▀▀▄ "; line3+="      ▄▀ "; line4+="   ▀▀▀▀  " ;;
            6) line1+="    ▄▀▀▀ "; line2+="   █▀▀▀▄ "; line3+="   ▀▄▄▄▀ "; line4+="    ▀▀▀  " ;;
            7) line1+="   ▀▀▀▀█ "; line2+="      █  "; line3+="     █   "; line4+="    ▀    " ;;
            8) line1+="    ▄▀▀▄ "; line2+="    ▄▀▀▄ "; line3+="   ▀▄▄▄▀ "; line4+="    ▀▀▀  " ;;
            9) line1+="    ▄▀▀▄ "; line2+="    ▀▀▀█ "; line3+="   ▀▄▄▄▀ "; line4+="    ▀▀▀  " ;;
            0) line1+="    ▄▀▀▄ "; line2+="   █  █  "; line3+="   ▀▄▄▄▀ "; line4+="    ▀▀▀  " ;;
            "@") line1+="   ▄▀▀▄  "; line2+="  █ █▀▄  "; line3+="  ▀▄▄▄▀  "; line4+="  ▀▀▀▀▀  " ;;
            "-") line1+="         "; line2+="   ▀▀▀▀  "; line3+="         "; line4+="         " ;;
            "_") line1+="         "; line2+="         "; line3+="         "; line4+="   ▀▀▀▀  " ;;
            ".") line1+="         "; line2+="         "; line3+="         "; line4+="    ▀    " ;;
            " ") line1+="    "; line2+="    "; line3+="    "; line4+="    " ;;
            *) line1+="   ▄▄▄  "; line2+="  █ ? █ "; line3+="   ▀▄▀  "; line4+="    ▀   " ;;
        esac
    done

    _output+=("${line1}")
    _output+=("${line2}")
    _output+=("${line3}")
    _output+=("${line4}")
}
