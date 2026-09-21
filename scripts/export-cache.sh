#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

DEST_CACHE=""

if [ -n "${1:-}" ]; then
    DEST_CACHE="$1"
elif [ -d "/mnt/d" ]; then
    DEST_CACHE="/mnt/d/nix-cache"
elif [ -d "/mnt/e" ]; then
    DEST_CACHE="/mnt/e/nix-cache"
elif [ -d "/run/media/${USER}" ] && [ -n "$(ls -A /run/media/${USER} 2>/dev/null)" ]; then
    FIRST_MOUNT=$(ls -d /run/media/${USER}/* | head -n 1)
    DEST_CACHE="${FIRST_MOUNT}/nix-cache"
else
    DEST_CACHE="${HOME}/.cache/nix-export-cache"
fi

echo "📦 Cache Target: $DEST_CACHE"
mkdir -p "$DEST_CACHE"

echo "🔨 Building Desktop top-level closure..."
DESKTOP_PATH=$(nix build .#nixosConfigurations.nixos.config.system.build.toplevel \
    --print-out-paths \
    --option download-attempts 10 \
    --option connect-timeout 20)

echo "💾 Exporting store paths to cache directory..."
nix copy --to "file://${DEST_CACHE}" "$DESKTOP_PATH"

echo "✅ Export finished successfully to: ${DEST_CACHE}"