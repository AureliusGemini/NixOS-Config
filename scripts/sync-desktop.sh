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

# Ubah ke path absolut demi keamanan eksekusi
CACHE_SRC=$(realpath "$CACHE_SRC")

echo "🔍 Checking network connection to Desktop (${DESKTOP_IP})..."
# Melakukan ping cepat (1 detik timeout) untuk memastikan desktop menyala
if ! ping -c 1 -W 1 "$DESKTOP_IP" >/dev/null 2>&1; then
    echo "❌ Error: Cannot ping Desktop at ${DESKTOP_IP}. Is it turned on and connected?"
    exit 1
fi

echo "🔗 Connecting to Desktop at ${DESKTOP_IP} over SSH..."
echo "📂 Source Cache: ${CACHE_SRC}"

# PERBAIKAN UTAMA: Cara menyalin isi dari cache berbasis file ke remote SSH
# Kita harus mendefinisikan cache asal menggunakan skema 'file://' sebagai substituter,
# lalu mencari semua valid path atau langsung memicu copy via store lokal jika jalurnya sinkron.
# Cara paling kokoh dan didukung resmi oleh Nix untuk memindahkan isi cache:
nix copy \
    --from "file://${CACHE_SRC}" \
    --to "ssh-ng://${DESKTOP_USER}@${DESKTOP_IP}?ssh-arguments=-C" \
    --all

echo "✅ Successfully transferred all closures to Desktop!"
