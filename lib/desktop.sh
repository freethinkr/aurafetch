#!/usr/bin/env bash
# ── AuraFetch: Desktop Environment Module ────────────────────

get_de() {
    local de="${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}"
    if [[ -z "$de" ]]; then
        # Try to detect from running processes
        for d in gnome-session plasmashell xfce4-session cinnamon-session mate-session budgie-panel lxqt-session; do
            if pgrep -x "$d" &>/dev/null; then
                case "$d" in
                    gnome-session)    de="GNOME" ;;
                    plasmashell)      de="KDE Plasma" ;;
                    xfce4-session)    de="Xfce" ;;
                    cinnamon-session) de="Cinnamon" ;;
                    mate-session)     de="MATE" ;;
                    budgie-panel)     de="Budgie" ;;
                    lxqt-session)     de="LXQt" ;;
                esac
                break
            fi
        done
    fi
    echo "${de:-unknown}"
}

get_wm() {
    # Try wmctrl first
    if command -v wmctrl &>/dev/null; then
        local wm
        wm=$(wmctrl -m 2>/dev/null | grep "Name:" | head -1 | cut -d: -f2 | xargs)
        [[ -n "$wm" ]] && { echo "$wm"; return; }
    fi

    # Check running window managers
    local wm_list="kwin_wayland kwin_x11 mutter muffin marco openbox i3 sway bspwm awesome herbstluftwm dwm xmonad qtile hyprland river labwc wayfire weston compiz fluxbox icewm jwm fvwm"
    for w in $wm_list; do
        if pgrep -x "$w" &>/dev/null; then
            echo "$w"
            return
        fi
    done
    echo "unknown"
}

get_display_server() {
    local dt="${XDG_SESSION_TYPE:-}"
    if [[ -z "$dt" ]]; then
        [[ -n "$WAYLAND_DISPLAY" ]] && dt="wayland"
        [[ -n "$DISPLAY" && -z "$dt" ]] && dt="x11"
    fi
    echo "${dt:-unknown}"
}

get_theme() {
    # Try GNOME/GTK
    if command -v gsettings &>/dev/null; then
        local theme
        theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
        [[ -n "$theme" && "$theme" != *"error"* ]] && { echo "$theme"; return; }
    fi

    # Try KDE
    if [[ -f "$HOME/.config/kdeglobals" ]]; then
        local theme
        theme=$(grep -A5 '\[General\]' "$HOME/.config/kdeglobals" 2>/dev/null | grep "^Name=" | head -1 | cut -d= -f2)
        [[ -n "$theme" ]] && { echo "$theme"; return; }
    fi

    # Try from env
    [[ -n "$GTK_THEME" ]] && { echo "$GTK_THEME"; return; }

    echo "unknown"
}

get_icons() {
    if command -v gsettings &>/dev/null; then
        local icons
        icons=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")
        [[ -n "$icons" && "$icons" != *"error"* ]] && { echo "$icons"; return; }
    fi

    if [[ -f "$HOME/.config/kdeglobals" ]]; then
        local icons
        icons=$(grep -A5 '\[Icons\]' "$HOME/.config/kdeglobals" 2>/dev/null | grep "^Theme=" | head -1 | cut -d= -f2)
        [[ -n "$icons" ]] && { echo "$icons"; return; }
    fi

    echo "unknown"
}

get_cursor() {
    if command -v gsettings &>/dev/null; then
        local c
        c=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null | tr -d "'")
        [[ -n "$c" && "$c" != *"error"* ]] && { echo "$c"; return; }
    fi
    echo "unknown"
}

get_font() {
    if command -v gsettings &>/dev/null; then
        local f
        f=$(gsettings get org.gnome.desktop.interface font-name 2>/dev/null | tr -d "'")
        [[ -n "$f" && "$f" != *"error"* ]] && { echo "$f"; return; }
    fi
    echo "unknown"
}

get_terminal() {
    local term=""
    local ppid_val="$$"

    # Walk up the process tree
    for _ in 1 2 3 4 5 6 7 8; do
        ppid_val=$(ps -o ppid= -p "$ppid_val" 2>/dev/null | tr -d ' ')
        [[ -z "$ppid_val" || "$ppid_val" == "0" ]] && break

        local pname
        pname=$(ps -o comm= -p "$ppid_val" 2>/dev/null)

        case "$pname" in
            kitty|alacritty|wezterm-gui|wezterm|foot|konsole|gnome-terminal*|xfce4-terminal|tilix|terminator|st|urxvt|xterm|yakuake|guake|cool-retro-term|sakura|terminology|deepin-terminal|lxterminal|mate-terminal|qterminal|roxterm|termite|tilda|contour|warp|rio|ghostty)
                term="$pname"
                break
                ;;
        esac
    done

    # Fallback
    if [[ -z "$term" ]]; then
        term="${TERM_PROGRAM:-${TERM:-unknown}}"
    fi

    echo "$term"
}
