#!/usr/bin/env bash
# scripts/pull-config.sh
# Pull config edits made elsewhere (e.g. on github.com) and optionally apply them.
#
# Usage:
#   ./scripts/pull-config.sh          # pull, show what changed, ask before rebuilding
#   ./scripts/pull-config.sh -y       # pull and rebuild without asking
#   ./scripts/pull-config.sh switch|test|boot   # choose the rebuild mode (default: switch)
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
ASSUME_YES=false
MODE="switch"

for arg in "$@"; do
    case "$arg" in
        -y|--yes) ASSUME_YES=true ;;
        switch|test|boot|build) MODE="$arg" ;;
        *) echo "Unknown argument: $arg"; exit 1 ;;
    esac
done

cd "$CONFIG_DIR"

# The flake host name equals networking.hostName: "nixos" (desktop) / "nixos-wsl" (laptop).
HOST="$(hostname)"

echo "📥 Pulling from remote (local edits are stashed and restored automatically)..."
OLD_HEAD="$(git rev-parse HEAD)"

# --autostash: safely stashes uncommitted changes and re-applies them afterwards.
# --rebase: puts any local, unpushed commits (e.g. from update.sh) on top of the remote ones.
if ! git pull --rebase --autostash; then
    echo "❌ Pull stopped (probably a conflict)."
    echo "   Fix the files git lists, then run: git rebase --continue"
    echo "   Or give up with:                   git rebase --abort"
    exit 1
fi

NEW_HEAD="$(git rev-parse HEAD)"

if [ "$OLD_HEAD" = "$NEW_HEAD" ]; then
    echo "✅ Already up to date."
else
    echo "🆕 Changes pulled:"
    git --no-pager log --oneline --stat "${OLD_HEAD}..${NEW_HEAD}" | head -n 40
fi

if [ "$ASSUME_YES" = false ]; then
    if [ ! -t 0 ]; then
        echo "ℹ️  No terminal attached: skipping rebuild (use -y to force)."
        exit 0
    fi
    read -rp "Rebuild '${HOST}' now with mode '${MODE}'? [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "Skipped rebuild. Run it later with: sudo nixos-rebuild ${MODE} --flake .#${HOST}"; exit 0; }
fi

echo "🚀 sudo nixos-rebuild ${MODE} --flake .#${HOST}"
sudo nixos-rebuild "$MODE" --flake ".#${HOST}"

echo "🎉 Done."
