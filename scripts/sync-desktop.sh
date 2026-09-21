#!/usr/bin/env bash
set -euo pipefail

DESKTOP_IP="${1:-192.168.50.2}"
DESKTOP_USER="${2:-aurelius}"
CACHE_SRC=""

# Auto-detect cache location if not provided
if [ -n "${3:-}" ]; then
    CACHE_SRC="$3"
elif [ -d "/mnt/d/nix-cache" ]; then
    CACHE_SRC="/mnt/d/nix-cache"
elif [ -d "${HOME}/.cache/nix-export-cache" ]; then
    CACHE_SRC="${HOME}/.cache/nix-export-cache"
else
    echo "❌ No cache directory found automatically! Specify path as 3rd argument."
    exit 1
fi

echo "🔗 Connecting to Desktop at ${DESKTOP_IP} over Ethernet..."
echo "📂 Source Cache: ${CACHE_SRC}"

# Push closures over SSH store protocol
nix copy --substituter-info --to "ssh-ng://${DESKTOP_USER}@${DESKTOP_IP}" "${CACHE_SRC}"/*

echo "✅ Successfully transferred all closures to Desktop!"