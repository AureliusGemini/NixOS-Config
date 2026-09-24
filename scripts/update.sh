#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

MODE="${1:-switch}"      # switch | test | boot | build
FLAKE_TARGET="${2:-}"   # nixos-wsl | nixos | auto
UPGRADE="${3:-false}"    # true | false

# Auto-detect target host if not specified
if [ -z "$FLAKE_TARGET" ] || [ "$FLAKE_TARGET" = "auto" ]; then
    if grep -q "WSL" /proc/version 2>/dev/null; then
        FLAKE_TARGET="nixos-wsl"
    else
        FLAKE_TARGET="nixos"
    fi
fi

echo "🔄 Syncing Git working tree..."
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "📦 Stashing local unstaged changes..."
    git stash push -m "update.sh auto-stash $(date '+%Y-%m-%d %H:%M:%S')"
    STASHED=true
else
    STASHED=false
fi

echo "🔄 Pulling remote updates..."
git pull --rebase || echo "⚠️ Git pull failed or no remote configured, continuing..."

if [ "$STASHED" = true ]; then
    echo "📦 Restoring local changes from stash..."
    git stash pop || echo "⚠️ Conflict while popping stash. Please review manually."
fi

if [ "$UPGRADE" = "true" ]; then
    echo "⬆️ Updating flake inputs..."
    nix flake update \
        --option download-attempts 10 \
        --option connect-timeout 20
fi

# Stage all tracked and untracked config/script changes to clear dirty status
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "📝 Auto-committing working directory state at ${TIMESTAMP}..."
git add -A
git commit -m "auto-save: ${TIMESTAMP}" || echo "ℹ️ Nothing new to commit."

echo "🚀 Rebuilding configuration ($FLAKE_TARGET) with mode: $MODE..."

sudo nixos-rebuild "$MODE" \
    --flake ".#${FLAKE_TARGET}" \
    --option download-attempts 10 \
    --option connect-timeout 20

echo "✅ Update complete!"