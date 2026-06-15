#!/bin/bash
# ===== Codex Sidebar Fix Tool (macOS) =====
# Fix: Codex icon missing from left sidebar
# Supports: VS Code / VS Code Insiders / Trae / Trae CN / Cursor / Windsurf
#
# Usage:
#   Terminal:  bash fix_codex_sidebar.sh
#   Finder:    双击 "双击修复Codex侧边栏.command"
#
# Original Windows version: https://github.com/your-repo/fix-codex-sidebar
# macOS port: adapts PowerShell logic to Bash + perl

set -euo pipefail

# ---- Color codes ----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color

echo ''
echo -e "  ${CYAN}===== Codex Sidebar Fix Tool =====${NC}"
echo -e "  ${CYAN}Fix: Codex icon missing from left sidebar${NC}"
echo -e "  ${CYAN}VS Code / Trae / Cursor / Windsurf${NC}"
echo -e "  ${CYAN}=====================================${NC}"
echo ''

# ---- IDE config directories (same as Windows version, relative to $HOME) ----
subs=('.vscode' '.vscode-insiders' '.trae' '.trae-cn' '.cursor' '.windsurf')
names=('VS Code' 'VS Code Insiders' 'Trae' 'Trae CN' 'Cursor' 'Windsurf')
total_fixed=0
total_found=0

for i in "${!subs[@]}"; do
    ext_root="$HOME/${subs[$i]}/extensions"

    if [ ! -d "$ext_root" ]; then
        continue
    fi

    # Find all OpenAI Codex extension directories
    for d in "$ext_root"/openai.chatgpt-*; do
        # Guard against glob that didn't match anything
        [ -d "$d" ] || continue

        pkg="$d/package.json"
        [ -f "$pkg" ] || continue

        ((total_found++)) || true

        # Extract version from directory name
        ver=$(basename "$d" | sed 's/openai\.chatgpt-//')

        echo -e "  ${YELLOW}${names[$i]} - Codex v$ver${NC}"
        echo -e "  ${GRAY}$pkg${NC}"

        # Check if the "when" condition exists in the file
        if grep -qF 'chatgpt.doesNotSupportSecondarySidebar' "$pkg"; then
            # ---- Create timestamped backup ----
            ts=$(date +'%Y%m%d_%H%M%S')
            cp "$pkg" "$pkg.bak_$ts"
            echo -e "  ${GREEN}[OK] Backup created  →  package.json.bak_$ts${NC}"

            # ---- Remove the "when" condition ----
            # The original PS regex: ',\s*[\r\n]+\s*"when"\s*:\s*"chatgpt\.doesNotSupportSecondarySidebar"'
            # This removes the comma (from previous line) + newline + "when" condition.
            # perl -0777 slurps the whole file; \s* matches whitespace including newlines.
            perl -0777 -pe 's/,\s*"when"\s*:\s*"chatgpt\.doesNotSupportSecondarySidebar"//g' \
                "$pkg" > "$pkg.tmp"
            mv "$pkg.tmp" "$pkg"

            echo -e "  ${GREEN}[OK] Removed when condition(s)${NC}"
            echo -e "  ${GREEN}[OK] Saved (UTF-8)${NC}"
            ((total_fixed++)) || true
        else
            echo -e "  ${GRAY}[SKIP] Already patched${NC}"
        fi
        echo ''
    done
done

# ---- Summary ----
if [ "$total_found" -eq 0 ]; then
    echo -e "  ${RED}[ERR] No Codex extension found${NC}"
    echo ''
    echo '  Searched the following paths:'
    echo ''
    for i in "${!subs[@]}"; do
        p="$HOME/${subs[$i]}/extensions"
        if [ -d "$p" ]; then
            echo -e "    ${GREEN}[Y]${NC} ${names[$i]}: $p"
        else
            echo -e "    ${GRAY}[N]${NC} ${names[$i]}: $p"
        fi
    done
    echo ''
    echo '  Make sure the Codex extension is installed in one of these IDEs.'
elif [ "$total_fixed" -gt 0 ]; then
    echo -e "  ${GREEN}[OK] Fixed $total_fixed extension(s). Please restart your IDE.${NC}"
else
    echo -e "  ${GRAY}[SKIP] All extensions already patched — no changes needed.${NC}"
fi

echo ''
