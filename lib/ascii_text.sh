#!/usr/bin/env bash
# ── AuraFetch: ASCII Text Generator ────────────────────────
# 4-line outline-art font for zero-dependency ASCII art

render_ascii_text() {
    local input=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local -n _output=$2
    local line1="" line2="" line3="" line4=""

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"
        case "$char" in
            A) line1+="  __  "; line2+=" / _\\ "; line3+="| |-| |"; line4+="|_| |_|" ;;
            B) line1+="|--\\ "; line2+="|--| "; line3+="|--| "; line4+="|__/ " ;;
            C) line1+=" ___ "; line2+="/ __|"; line3+="| |  "; line4+="\\___|" ;;
            D) line1+="|--\\ "; line2+="| | \\"; line3+="| | |"; line4+="|__/ " ;;
            E) line1+="|--- "; line2+="|--- "; line3+="|    "; line4+="|___ " ;;
            F) line1+="|--- "; line2+="|--- "; line3+="|    "; line4+="|    " ;;
            G) line1+=" ___ "; line2+="/ __|"; line3+="| | |"; line4+="\\___|" ;;
            H) line1+="|  | "; line2+="|--| "; line3+="|  | "; line4+="|  | " ;;
            I) line1+=" --- "; line2+="  |  "; line3+="  |  "; line4+=" --- " ;;
            J) line1+="  -- "; line2+="   | "; line3+=" | | "; line4+=" \\_/ " ;;
            K) line1+="|  / "; line2+="|<   "; line3+="| \\  "; line4+="|  \\ " ;;
            L) line1+="|    "; line2+="|    "; line3+="|    "; line4+="|___ " ;;
            M) line1+="|\\/| "; line2+="|  | "; line3+="|  | "; line4+="|  | " ;;
            N) line1+="|\\ | "; line2+="| \\| "; line3+="|  | "; line4+="|  | " ;;
            O) line1+=" ___ "; line2+="/ _ \\"; line3+="| | |"; line4+="\\___/" ;;
            P) line1+="|--\\ "; line2+="|--| "; line3+="|    "; line4+="|    " ;;
            Q) line1+=" ___ "; line2+="/ _ \\"; line3+="| |/|"; line4+="\\_\\_\\\\" ;;
            R) line1+="|--\\ "; line2+="|--| "; line3+="| \\  "; line4+="|  \\ " ;;
            S) line1+=" ___ "; line2+="/ __|"; line3+="\\__ \\"; line4+="|___/" ;;
            T) line1+=" --- "; line2+="  |  "; line3+="  |  "; line4+="  |  " ;;
            U) line1+="|  | "; line2+="|  | "; line3+="|  | "; line4+="\\__/ " ;;
            V) line1+="\\  / "; line2+=" \\/  "; line3+=" \\/  "; line4+="  V  " ;;
            W) line1+="\\/\\/ "; line2+="\\/\\/ "; line3+="    "; line4+="    " ;;
            X) line1+="\\  / "; line2+=" \\/  "; line3+=" /\\  "; line4+="/  \\ " ;;
            Y) line1+="\\  / "; line2+=" \\/  "; line3+="  |  "; line4+="  |  " ;;
            Z) line1+=" --- "; line2+="  /  "; line3+=" /   "; line4+=" --- " ;;
            1) line1+="  /| "; line2+=" / | "; line3+="   | "; line4+="   | " ;;
            2) line1+=" --- "; line2+="  _/ "; line3+=" /   "; line4+=" --- " ;;
            3) line1+=" --- "; line2+="  -_|"; line3+="  -_|"; line4+=" --- " ;;
            4) line1+="|  | "; line2+="|__| "; line3+="   | "; line4+="   | " ;;
            5) line1+="|--- "; line2+="|--- "; line3+="  -_|"; line4+=" --- " ;;
            6) line1+="|--- "; line2+="|--\\ "; line3+="|--| "; line4+="|__/ " ;;
            7) line1+=" --- "; line2+="   / "; line3+="  /  "; line4+=" /   " ;;
            8) line1+=" --- "; line2+="|---|"; line3+="|---|"; line4+=" --- " ;;
            9) line1+=" --- "; line2+="|---|"; line3+="  -_|"; line4+=" --- " ;;
            0) line1+=" --- "; line2+="|  | "; line3+="|  | "; line4+=" --- " ;;
            "@") line1+=" __  "; line2+="/ _| "; line3+="| @| "; line4+="\\__| " ;;
            "-") line1+="     "; line2+=" --- "; line3+="     "; line4+="     " ;;
            "_") line1+="     "; line2+="     "; line3+="     "; line4+=" --- " ;;
            ".") line1+="     "; line2+="     "; line3+="     "; line4+="  .  " ;;
            " ") line1+="    "; line2+="     "; line3+="     "; line4+="     " ;;
            *) line1+=" --- "; line2+="| ? |"; line3+=" --- "; line4+="     " ;;
        esac
    done

    _output+=("${line1}")
    _output+=("${line2}")
    _output+=("${line3}")
    _output+=("${line4}")
}
