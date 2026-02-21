#!/usr/bin/env bash
# ╔═══════════════════════════════════════════════════════════╗
# ║              AURAFETCH — Uninstaller                      ║
# ╚═══════════════════════════════════════════════════════════╝

set -e

INSTALL_DIR="/usr/local/bin"
SHARE_DIR="/usr/local/share/aurafetch"

echo ""
echo -e "  \033[1;96m✦ AuraFetch Uninstaller ✦\033[0m"
echo -e "  \033[90m────────────────────────────\033[0m"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo -e "  \033[93m⚠  Need sudo to uninstall.\033[0m"
    sudo "$0" "$@"
    exit $?
fi

echo -e "  \033[96m▸\033[0m Removing aurafetch binary..."
rm -f "${INSTALL_DIR}/aurafetch"

echo -e "  \033[96m▸\033[0m Removing shared files..."
rm -rf "${SHARE_DIR}"

echo ""
echo -e "  \033[92m✓  Uninstalled!\033[0m"
echo -e "  \033[90m  Config at ~/.config/aurafetch/ was kept.\033[0m"
echo ""
