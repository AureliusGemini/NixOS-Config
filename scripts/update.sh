#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

MODE="${1:-switch}"      # switch | test | boot | build
FLAKE_TARGET="${2:-}"   # nixos-wsl | nixos | auto
UPGRADE="${3:-false}"    # true | false

NIX_OPTS=(--option download-attempts 10 --option connect-timeout 20)

# Auto-detect target host if not specified
if [ -z "$FLAKE_TARGET" ] || [ "$FLAKE_TARGET" = "auto" ]; then
    if grep -q "WSL" /proc/version 2>/dev/null; then
        FLAKE_TARGET="nixos-wsl"
    else
        FLAKE_TARGET="nixos"
    fi
fi

echo "🔄 Syncing Git working tree..."
STASHED=false
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "📦 Stashing local unstaged changes to pull clean remote..."
    git stash push -m "update.sh auto-stash $(date '+%Y-%m-%d %H:%M:%S')"
    STASHED=true
fi

echo "🔄 Pulling remote updates..."
git pull --rebase || echo "⚠️ Git pull failed or no remote configured, continuing..."

if [ "$STASHED" = true ]; then
    echo "📦 Restoring local changes from stash..."
    git stash pop || echo "⚠️ Conflict while popping stash. Please review manually."
fi

if [ "$UPGRADE" = "true" ]; then
    echo "⬆️ Updating flake inputs..."
    nix flake update "${NIX_OPTS[@]}"
fi

# Beri tahu Git tentang file baru agar dibaca Nix Flake,
# tetapi JANGAN di-commit dulu sebelum build terbukti sukses.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git add -N . || true
fi

echo "🚀 Rebuilding configuration ($FLAKE_TARGET) with mode: $MODE..."
if command -v nh >/dev/null 2>&1; then
    NH_ARGS=(os "$MODE" "$CONFIG_DIR" --hostname "$FLAKE_TARGET")
    # Minta konfirmasi (setelah menampilkan diff) hanya jika interaktif
    if [ -t 0 ] && [ -t 1 ]; then
        NH_ARGS+=(--ask)
    fi
    # nh memanggil sudo sendiri; jangan di-prefix sudo
    nh "${NH_ARGS[@]}" -- "${NIX_OPTS[@]}"
else
    echo "ℹ️ nh not found, falling back to nixos-rebuild..."
    sudo nixos-rebuild "$MODE" --flake ".#${FLAKE_TARGET}" "${NIX_OPTS[@]}"
fi

# INTERACTIVE GIT COMMIT (hanya berjalan jika REBUILD DI ATAS SUKSES)
if ! git diff-index --quiet HEAD -- 2>/dev/null || [ -n "$(git status --porcelain)" ]; then
    echo "📝 Configuration applied successfully. Uncommitted changes detected."
    git status -s

    if [ -t 0 ]; then
        read -rp "Enter commit message (Press Enter for auto-timestamp): " USER_COMMIT_MSG
    else
        USER_COMMIT_MSG=""
    fi

    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    COMMIT_MSG="${USER_COMMIT_MSG:-system auto-update: ${TIMESTAMP} ($FLAKE_TARGET)}"

    echo "➕ Saving approved configuration to Git history..."
    git add -A
    git commit -m "$COMMIT_MSG"
else
    echo "ℹ️ Working tree clean, nothing to commit."
fi

echo "🎉 ✅ Update and deployment complete!"