#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

MODE="${1:-switch}"  # switch | test | boot
LOCAL_CACHE="${2:-}" # Path to cache directory (e.g. /mnt/d/nix-cache or USB mount)

echo "⚡ Rebuilding Desktop strictly offline..."

EXTRA_FLAGS=("--option" "substitute" "false")

if [ -n "$LOCAL_CACHE" ] && [ -d "$LOCAL_CACHE" ]; then
    echo "📁 Using local store cache from: $LOCAL_CACHE"
    EXTRA_FLAGS+=("--option" "extra-substituters" "file://${LOCAL_CACHE}")
fi

sudo nixos-rebuild "$MODE" --flake .#nixos "${EXTRA_FLAGS[@]}"

rm -f ./result
echo "🎉 Desktop updated offline successfully!"