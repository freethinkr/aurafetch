#!/usr/bin/env bash
# ── AuraFetch: Color & Theme Management ──────────────────────

# Reset
RST="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"

# Standard foreground
C_BLACK="\033[30m";   C_RED="\033[31m";   C_GREEN="\033[32m";  C_YELLOW="\033[33m"
C_BLUE="\033[34m";    C_MAGENTA="\033[35m"; C_CYAN="\033[36m"; C_WHITE="\033[37m"

# Bright foreground
C_BBLACK="\033[90m";  C_BRED="\033[91m";  C_BGREEN="\033[92m"; C_BYELLOW="\033[93m"
C_BBLUE="\033[94m";   C_BMAGENTA="\033[95m"; C_BCYAN="\033[96m"; C_BWHITE="\033[97m"

# Background (for palette)
BG_BLACK="\033[40m";  BG_RED="\033[41m";  BG_GREEN="\033[42m"; BG_YELLOW="\033[43m"
BG_BLUE="\033[44m";   BG_MAGENTA="\033[45m"; BG_CYAN="\033[46m"; BG_WHITE="\033[47m"
BG_BBLACK="\033[100m"; BG_BRED="\033[101m"; BG_BGREEN="\033[102m"; BG_BYELLOW="\033[103m"
BG_BBLUE="\033[104m"; BG_BMAGENTA="\033[105m"; BG_BCYAN="\033[106m"; BG_BWHITE="\033[107m"

# ── Distro-based color themes ────────────────────────────────
# Each theme: LOGO_C1 LOGO_C2 ACCENT LABEL SEPARATOR HEADER VALUE
declare -A DISTRO_THEMES

set_theme_colors() {
    local distro_id="$1"

    # Defaults
    LOGO_C1="${C_BCYAN}"
    LOGO_C2="${C_BBLUE}"
    T_ACCENT="${C_BCYAN}"
    T_LABEL="${C_BCYAN}"
    T_SEP="${C_BBLACK}"
    T_HEADER="${BOLD}${C_BCYAN}"
    T_VALUE="${C_BWHITE}"
    T_DOT="${C_BCYAN}"
    T_DIM="${C_BBLACK}"
    T_TITLE="${BOLD}${C_BCYAN}"

    case "$distro_id" in
        arch|archcraft|archlabs|archstrike|arco)
            LOGO_C1="${C_BCYAN}"; LOGO_C2="${C_BCYAN}"
            T_ACCENT="${C_BCYAN}"; T_LABEL="${C_BCYAN}"; T_HEADER="${BOLD}${C_BCYAN}"
            T_DOT="${C_BCYAN}"; T_TITLE="${BOLD}${C_BCYAN}"
            ;;
        kubuntu)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        ubuntu|lubuntu|xubuntu|ubuntu_mate|ubuntu_budgie)
            LOGO_C1="${C_BRED}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BRED}"; T_LABEL="${C_BRED}"; T_HEADER="${BOLD}${C_BRED}"
            T_DOT="${C_BRED}"; T_TITLE="${BOLD}${C_BRED}"
            ;;
        fedora|fedora_coreos|fedora_silverblue)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        debian)
            LOGO_C1="${C_BRED}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BRED}"; T_LABEL="${C_BRED}"; T_HEADER="${BOLD}${C_BRED}"
            T_DOT="${C_BRED}"; T_TITLE="${BOLD}${C_BRED}"
            ;;
        manjaro)
            LOGO_C1="${C_BGREEN}"; LOGO_C2="${C_BGREEN}"
            T_ACCENT="${C_BGREEN}"; T_LABEL="${C_BGREEN}"; T_HEADER="${BOLD}${C_BGREEN}"
            T_DOT="${C_BGREEN}"; T_TITLE="${BOLD}${C_BGREEN}"
            ;;
        opensuse*|suse)
            LOGO_C1="${C_BGREEN}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BGREEN}"; T_LABEL="${C_BGREEN}"; T_HEADER="${BOLD}${C_BGREEN}"
            T_DOT="${C_BGREEN}"; T_TITLE="${BOLD}${C_BGREEN}"
            ;;
        nixos)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BCYAN}"
            T_ACCENT="${C_BCYAN}"; T_LABEL="${C_BCYAN}"; T_HEADER="${BOLD}${C_BCYAN}"
            T_DOT="${C_BCYAN}"; T_TITLE="${BOLD}${C_BCYAN}"
            ;;
        pop)
            LOGO_C1="${C_BCYAN}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BCYAN}"; T_LABEL="${C_BCYAN}"; T_HEADER="${BOLD}${C_BCYAN}"
            T_DOT="${C_BCYAN}"; T_TITLE="${BOLD}${C_BCYAN}"
            ;;
        kali)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BBLACK}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        gentoo)
            LOGO_C1="${C_BMAGENTA}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BMAGENTA}"; T_LABEL="${C_BMAGENTA}"; T_HEADER="${BOLD}${C_BMAGENTA}"
            T_DOT="${C_BMAGENTA}"; T_TITLE="${BOLD}${C_BMAGENTA}"
            ;;
        void)
            LOGO_C1="${C_BGREEN}"; LOGO_C2="${C_BBLACK}"
            T_ACCENT="${C_BGREEN}"; T_LABEL="${C_BGREEN}"; T_HEADER="${BOLD}${C_BGREEN}"
            T_DOT="${C_BGREEN}"; T_TITLE="${BOLD}${C_BGREEN}"
            ;;
        linuxmint|lmde)
            LOGO_C1="${C_BGREEN}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BGREEN}"; T_LABEL="${C_BGREEN}"; T_HEADER="${BOLD}${C_BGREEN}"
            T_DOT="${C_BGREEN}"; T_TITLE="${BOLD}${C_BGREEN}"
            ;;
        endeavouros)
            LOGO_C1="${C_BMAGENTA}"; LOGO_C2="${C_BRED}"
            T_ACCENT="${C_BMAGENTA}"; T_LABEL="${C_BMAGENTA}"; T_HEADER="${BOLD}${C_BMAGENTA}"
            T_DOT="${C_BMAGENTA}"; T_TITLE="${BOLD}${C_BMAGENTA}"
            ;;
        garuda)
            LOGO_C1="${C_BCYAN}"; LOGO_C2="${C_BRED}"
            T_ACCENT="${C_BRED}"; T_LABEL="${C_BRED}"; T_HEADER="${BOLD}${C_BRED}"
            T_DOT="${C_BRED}"; T_TITLE="${BOLD}${C_BRED}"
            ;;
        cachyos)
            LOGO_C1="${C_BCYAN}"; LOGO_C2="${C_BGREEN}"
            T_ACCENT="${C_BCYAN}"; T_LABEL="${C_BCYAN}"; T_HEADER="${BOLD}${C_BCYAN}"
            T_DOT="${C_BCYAN}"; T_TITLE="${BOLD}${C_BCYAN}"
            ;;
        zorin)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        elementary)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        rocky)
            LOGO_C1="${C_BGREEN}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BGREEN}"; T_LABEL="${C_BGREEN}"; T_HEADER="${BOLD}${C_BGREEN}"
            T_DOT="${C_BGREEN}"; T_TITLE="${BOLD}${C_BGREEN}"
            ;;
        alpine)
            LOGO_C1="${C_BBLUE}"; LOGO_C2="${C_BWHITE}"
            T_ACCENT="${C_BBLUE}"; T_LABEL="${C_BBLUE}"; T_HEADER="${BOLD}${C_BBLUE}"
            T_DOT="${C_BBLUE}"; T_TITLE="${BOLD}${C_BBLUE}"
            ;;
        nobara)
            LOGO_C1="${C_BWHITE}"; LOGO_C2="${C_BRED}"
            T_ACCENT="${C_BRED}"; T_LABEL="${C_BRED}"; T_HEADER="${BOLD}${C_BRED}"
            T_DOT="${C_BRED}"; T_TITLE="${BOLD}${C_BRED}"
            ;;
        artix)
            LOGO_C1="${C_BCYAN}"; LOGO_C2="${C_BCYAN}"
            T_ACCENT="${C_BCYAN}"; T_LABEL="${C_BCYAN}"; T_HEADER="${BOLD}${C_BCYAN}"
            T_DOT="${C_BCYAN}"; T_TITLE="${BOLD}${C_BCYAN}"
            ;;
        *)
            # Keep defaults (cyan theme)
            ;;
    esac
}
