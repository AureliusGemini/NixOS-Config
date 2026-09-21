#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

MODE="${1:-switch}"      # switch | test | boot | build
FLAKE_TARGET="${2:-}"   # nixos | wsl | auto
UPGRADE="${3:-false}"    # true | false

# Determine target host if not specified
if [ -z "$FLAKE_TARGET" ] || [ "$FLAKE_TARGET" = "auto" ]; then
    if grep -q "WSL" /proc/version 2>/dev/null; then
        FLAKE_TARGET="wsl"
    else
        FLAKE_TARGET="nixos"
    fi
fi

echo "🔄 Updating Git repository..."
git pull --rebase || echo "⚠️ Git pull failed, continuing with local state..."

if [ "$UPGRADE" = "true" ]; then
    echo "⬆️ Updating flake inputs..."
    nix flake update \
        --option download-attempts 10 \
        --option connect-timeout 20
fi

echo "🚀 Rebuilding configuration ($FLAKE_TARGET) with mode: $MODE..."

sudo nixos-rebuild "$MODE" \
    --flake ".#${FLAKE_TARGET}" \
    --option download-attempts 10 \
    --option connect-timeout 20

echo "✅ Update complete!"