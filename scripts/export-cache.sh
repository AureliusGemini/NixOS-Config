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

# Pastikan path diubah ke absolut (sangat penting untuk WSL mount path)
DEST_CACHE=$(realpath "$DEST_CACHE")
echo "📦 Cache Target: ${DEST_CACHE}"
mkdir -p "${DEST_CACHE}"

# PERBAIKAN GIT: Gunakan git stash alih-alih auto-commit paksa yang mengotori riwayat git
STASHED=false
if ! git diff-index --quiet HEAD --; then
    echo "⚠️ Git tree is dirty. Stashing local changes temporarily to ensure clean build..."
    git stash -u
    STASHED=true
fi

# Trap untuk memastikan jika skrip error di tengah jalan, git stash dan symlink tetap dibersihkan
cleanup() {
    if [ "$STASHED" = true ]; then
        echo "🔄 Restoring stashed local changes..."
        git stash pop || echo "⚠️ Warning: Failed to pop stash automatically. Please check 'git stash list'."
    fi
    rm -f ./result
}
trap cleanup EXIT

echo "🔨 Building Desktop top-level closure..."
# Menggunakan bendera --no-link agar tidak membuat file symlink './result' yang mengotori git
DESKTOP_PATH=$(nix build .#nixosConfigurations.nixos.config.system.build.toplevel \
    --print-out-paths \
    --no-link \
    --option download-attempts 10 \
    --option connect-timeout 20)

echo "💾 Exporting store paths to cache directory..."
nix copy --to "file://${DEST_CACHE}" "$DESKTOP_PATH"

# OPSIONAL TAPI DIALAMI: Salin juga flake inputs agar evaluasi offline berjalan mulus
echo "📦 Copying flake inputs to cache..."
nix flake archive --to "file://${DEST_CACHE}"

echo "✅ Export finished successfully to: ${DEST_CACHE}"
