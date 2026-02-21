#!/usr/bin/env bash
# ── AuraFetch: ASCII Text Generator ────────────────────────
# Compact 3-line outline font for best mobile compatibility

render_ascii_text() {
    local input=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local -n _output=$2
    local line1="" line2="" line3=""

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            A) line1+="  /_\\  "; line2+=" |---| "; line3+=" |   | " ;;
            B) line1+=" |---  "; line2+=" |---/ "; line3+=" |---  " ;;
            C) line1+=" |---  "; line2+=" |     "; line3+=" |---  " ;;
            D) line1+=" |---  "; line2+=" |   | "; line3+=" |---/ " ;;
            E) line1+=" |---  "; line2+=" |---  "; line3+=" |---  " ;;
            F) line1+=" |---  "; line2+=" |---  "; line3+=" |     " ;;
            G) line1+=" |---  "; line2+=" |  -| "; line3+=" |___| " ;;
            H) line1+=" |  |  "; line2+=" |--|  "; line3+=" |  |  " ;;
            I) line1+="  ---  "; line2+="   |   "; line3+="  ---  " ;;
            J) line1+="  ---  "; line2+="   |   "; line3+="  _|   " ;;
            K) line1+=" |  /  "; line2+=" |<    "; line3+=" |  \\  " ;;
            L) line1+=" |     "; line2+=" |     "; line3+=" |___  " ;;
            M) line1+=" |\\/|  "; line2+=" |  |  "; line3+=" |  |  " ;;
            N) line1+=" |\\ |  "; line2+=" | \\|  "; line3+=" |  |  " ;;
            O) line1+=" |---| "; line2+=" |   | "; line3+=" |---| " ;;
            P) line1+=" |---  "; line2+=" |---/ "; line3+=" |     " ;;
            Q) line1+=" |---| "; line2+=" |   | "; line3+=" |---X " ;;
            R) line1+=" |---  "; line2+=" |---/ "; line3+=" |  \\  " ;;
            S) line1+="  ---  "; line2+="  \\    "; line3+="  ---  " ;;
            T) line1+="  ---  "; line2+="   |   "; line3+="   |   " ;;
            U) line1+=" |   | "; line2+=" |   | "; line3+=" |___/ " ;;
            V) line1+=" \\   / "; line2+="  \\ /  "; line3+="   V   " ;;
            W) line1+=" \\/\\/  "; line2+=" \\/\\/  "; line3+="       " ;;
            X) line1+=" \\  /  "; line2+="  ><   "; line3+=" /  \\  " ;;
            Y) line1+=" \\  /  "; line2+="  V    "; line3+="  |    " ;;
            Z) line1+="  ---  "; line2+="  /    "; line3+="  ---  " ;;
            1) line1+="   /|  "; line2+="    |  "; line3+="    |  " ;;
            2) line1+="  ---  "; line2+="   _/  "; line3+="  /__  " ;;
            3) line1+="  ---  "; line2+="   -_| "; line3+="  ---  " ;;
            4) line1+=" |   | "; line2+=" |___| "; line3+="     | " ;;
            5) line1+=" |---  "; line2+="  ---  "; line3+="  ---/ " ;;
            6) line1+=" |---  "; line2+=" |---  "; line3+=" |___/ " ;;
            7) line1+="  ---  "; line2+="    /  "; line3+="   /   " ;;
            8) line1+="  ---  "; line2+=" |---| "; line3+="  ---  " ;;
            9) line1+="  ---  "; line2+=" |---| "; line3+="  ---/ " ;;
            0) line1+="  ---  "; line2+=" | | | "; line3+="  ---  " ;;
            "@") line1+=" /---  "; line2+=" | @|  "; line3+=" \\___  " ;;
            "-") line1+="       "; line2+="  ---  "; line3+="       " ;;
            "_") line1+="       "; line2+="       "; line3+="  ---  " ;;
            ".") line1+="       "; line2+="       "; line3+="   .   " ;;
            " ") line1+="   "; line2+="   "; line3+="   " ;;
            *) line1+="  ---  "; line2+=" | ? | "; line3+="  ---  " ;;
        esac
    done

    _output+=("${line1}")
    _output+=("${line2}")
    _output+=("${line3}")
}
