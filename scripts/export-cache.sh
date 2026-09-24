#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

DEST_CACHE="${1:-}"

if [ -z "$DEST_CACHE" ]; then
    if grep -q "WSL" /proc/version 2>/dev/null; then
        echo "📂 Opening Windows File Explorer to select/verify target location..."
        explorer.exe . &
        DEFAULT_TARGET="/mnt/c/nix-cache"
    else
        echo "📂 Opening default file manager..."
        xdg-open . &
        DEFAULT_TARGET="${HOME}/.cache/nix-export-cache"
    fi

    echo "Default target: ${DEFAULT_TARGET}"
    read -rp "Enter/Paste target cache folder path [Press Enter for default]: " INPUT_PATH
    DEST_CACHE="${INPUT_PATH:-$DEFAULT_TARGET}"
fi

echo "📦 Cache Target: ${DEST_CACHE}"
mkdir -p "${DEST_CACHE}"

# Clean git tree auto-commit check if dirty before building
if ! git diff-index --quiet HEAD --; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "⚠️ Git tree is dirty. Auto-committing changes prior to export build..."
    git add .
    git commit -m "wsl export auto-save: ${TIMESTAMP}" || true
fi

echo "🔨 Building Desktop top-level closure..."
DESKTOP_PATH=$(nix build .#nixosConfigurations.nixos.config.system.build.toplevel \
    --print-out-paths \
    --option download-attempts 10 \
    --option connect-timeout 20)

echo "💾 Exporting store paths to cache directory..."
nix copy --to "file://${DEST_CACHE}" "$DESKTOP_PATH"

echo "✅ Export finished successfully to: ${DEST_CACHE}"