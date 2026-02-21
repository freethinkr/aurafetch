#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════╗
# ║              AURAFETCH — Installer                        ║
# ╚═══════════════════════════════════════════════════════════╝

set -e

INSTALL_DIR="/usr/local/bin"
SHARE_DIR="/usr/local/share/aurafetch"
CONFIG_DIR="$HOME/.config/aurafetch"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "  \033[1;96m✦ AuraFetch Installer ✦\033[0m"
echo -e "  \033[90m──────────────────────────\033[0m"
echo ""

# Check if running as root for system install
if [[ $EUID -ne 0 ]]; then
    echo -e "  \033[93m⚠  Need sudo for system install.\033[0m"
    echo -e "  \033[90m  Re-running with sudo...\033[0m"
    echo ""
    sudo "$0" "$@"
    exit $?
fi

# Install main script
echo -e "  \033[96m▸\033[0m Installing aurafetch to ${INSTALL_DIR}..."
cp "${SCRIPT_DIR}/aurafetch" "${INSTALL_DIR}/aurafetch"
chmod +x "${INSTALL_DIR}/aurafetch"

# Install lib & ascii to share dir
echo -e "  \033[96m▸\033[0m Installing libraries to ${SHARE_DIR}..."
mkdir -p "${SHARE_DIR}"
cp -r "${SCRIPT_DIR}/lib" "${SHARE_DIR}/"
cp -r "${SCRIPT_DIR}/ascii" "${SHARE_DIR}/"

# Create user config dir
REAL_HOME=$(eval echo "~${SUDO_USER:-$USER}")
REAL_CONFIG="${REAL_HOME}/.config/aurafetch"
if [[ ! -d "${REAL_CONFIG}" ]]; then
    echo -e "  \033[96m▸\033[0m Creating config directory..."
    mkdir -p "${REAL_CONFIG}"
    cp "${SCRIPT_DIR}/config/aurafetch.conf" "${REAL_CONFIG}/"
    # Fix ownership
    if [[ -n "$SUDO_USER" ]]; then
        chown -R "${SUDO_USER}:${SUDO_USER}" "${REAL_CONFIG}"
    fi
fi

echo ""
echo -e "  \033[92m✓  Installation complete!\033[0m"
echo -e "  \033[90m  Run \033[1;97maurafetch\033[0;90m to get started.\033[0m"
echo ""
