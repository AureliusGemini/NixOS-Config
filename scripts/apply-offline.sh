#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${HOME}/nixos-config"
cd "$CONFIG_DIR"

MODE="${1:-switch}"  # switch | test | boot
LOCAL_CACHE="${2:-}" # Path to cache directory (e.g. /mnt/d/nix-cache)

echo "⚡ Rebuilding Desktop strictly offline..."

# PENTING untuk Flakes: Otomatis melakukan track pada file baru (jika ada) 
# agar Nix mendeteksi perubahan meskipun saat offline.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "📦 Staging untracked files for Nix Flake..."
    git add -N . || true
fi

# Bendera utama untuk memaksa Nix tidak mengambil data dari internet
EXTRA_FLAGS=(
    "--option" "substitute" "false"
    "--option" "fallback" "false"      # Mencegah mencoba download jika substituter gagal
    "--no-link"                        # Memastikan tidak membuat symlink ./result yang mengotori folder
)

if [ -n "$LOCAL_CACHE" ]; then
    # Mengubah path relatif menjadi absolut agar aman saat sudo berpindah konteks
    ABS_CACHE=$(realpath "$LOCAL_CACHE")
    
    if [ -d "$ABS_CACHE" ]; then
        echo "📁 Using local store cache from: $ABS_CACHE"
        EXTRA_FLAGS+=("--option" "extra-substituters" "file://${ABS_CACHE}")
    else
        echo "⚠️ Warning: Cache directory '$LOCAL_CACHE' not found. Proceeding purely offline."
    fi
fi

# Eksekusi rebuild
echo "🚀 Executing: nixos-rebuild $MODE --flake .#nixos"
sudo nixos-rebuild "$MODE" --flake .#nixos "${EXTRA_FLAGS[@]}"

echo "🎉 Desktop updated offline successfully!"
