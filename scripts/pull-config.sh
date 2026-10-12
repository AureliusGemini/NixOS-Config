#!/usr/bin/env bash

# Keluar jika terjadi error
set -e

# Path ke repositori NixOS Anda (sesuaikan jika berbeda)
CONFIG_DIR="$HOME/NixOS-Config"

echo "=== Memulai sinkronisasi dari GitHub ==="
cd "$CONFIG_DIR"

# 1. Pastikan repositori lokal bersih dari perubahan tak berkomitmen
if ! git diff-index --quiet HEAD --; then
    echo "⚠️ Peringatan: Ada perubahan lokal yang belum di-commit!"
    echo "Silakan pilih tindakan:"
    select opt in "Simpan sementara (Stash)" "Batalkan perubahan lokal (Hard Reset)" "Batalkan proses pull"; do
        case $opt in
            "Simpan sementara (Stash)")
                git stash
                break
                ;;
            "Batalkan perubahan lokal (Hard Reset)")
                git reset --hard HEAD
                break
                ;;
            "Batalkan proses pull")
                echo "Proses dihentikan."
                exit 0
                ;;
        esac
    done
fi

# 2. Ambil perubahan terbaru dari remote
echo "Fetching dari remote repository..."
git fetch origin main

# 3. Cek apakah ada pembaruan di upstream
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✅ Konfigurasi lokal sudah up-to-date dengan GitHub. Tidak ada yang diunduh."
    exit 0
fi

# 4. Lakukan pull
echo "Mengunduh pembaruan terbaru..."
git pull origin main

# 5. Jika sebelumnya melakukan stash, kembalikan perubahannya
if git stash list | grep -q "stash@{0}"; then
    echo "Mengembalikan perubahan lokal yang disimpan sementara..."
    git stash pop || echo "⚠️ Terjadi konflik kecil saat mengembalikan stash. Selesaikan secara manual."
fi

# 6. Tanyakan apakah ingin langsung rebuild system
echo "----------------------------------------"
read -p "Apakah Anda ingin langsung menerapkan (rebuild) konfigurasi baru? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Menjalankan rebuild..."
    # Sesuaikan perintah rebuild Anda (misal pakai flake: sudo nixos-rebuild switch --flake .#desktop)
    sudo nixos-rebuild switch
else
    echo "Pembaruan selesai diunduh. Anda bisa melakukan rebuild manual nanti."
fi
