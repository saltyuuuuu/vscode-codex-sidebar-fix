#!/bin/bash
# =====================================================
#  双击修复 Codex 侧边栏 (macOS)
#  Double-click to fix Codex sidebar icon
# =====================================================

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Run the main fix script
cd "$SCRIPT_DIR"
bash "$SCRIPT_DIR/fix_codex_sidebar.sh"

# Keep the terminal window open so the user can read the output
echo ''
echo 'Press any key to close this window...'
read -n 1 -s
