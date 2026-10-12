# 📌 Panduan Cepat & Pengingat Skrip NixOS-Config

Berkas ini berfungsi sebagai pengingat perintah terminal, parameter argumen, dan jalur (*paths*) penting yang perlu disesuaikan pada kelima skrip manajemen sistem NixOS Anda.

---

## 🚀 Ringkasan Perintah Terminal (Siap Salin)

| Nama Skrip | Fungsi Utama | Contoh Perintah di Terminal |
| :--- | :--- | :--- |
| **1. `pull-config.sh`** | Sinkronisasi aman perubahan dari GitHub web | `./scripts/pull-config.sh` |
| **2. `update.sh`** | Update sistem online + auto-commit aman | `./scripts/update.sh switch auto false` |
| **3. `export-cache.sh`** | Membuat biner cache lokal (WSL/Online) | `./scripts/export-cache.sh /mnt/c/nix-cache` |
| **4. `sync-desktop.sh`**| Transfer biner cache lewat LAN (SSH-NG) | `./scripts/sync-desktop.sh 192.168.50.2 aurelius` |
| **5. `apply-offline.sh`**| Memasang konfigurasi secara *pure offline* | `./scripts/apply-offline.sh switch /mnt/d/nix-cache` |

---

## 🛠️ Detail Argumen & Parameter Skrip

### 1. `pull-config.sh` (Skrip Ke-5)
Menarik perubahan jika Anda sempat mengedit konfigurasi langsung di web GitHub.
*   **Tanpa Argumen:** Otomatis mendeteksi konflik lokal, melakukan *stash* jika kotor, lalu menanyakan apakah ingin langsung melakukan `nixos-rebuild`.

### 2. `update.sh`
*   **Argumen 1 (Mode):** `switch` (default) | `test` | `boot` | `build`
*   **Argumen 2 (Target):** `auto` (default - deteksi WSL vs Desktop) | `nixos` | `nixos-wsl`
*   **Argumen 3 (Upgrade):** `false` (default) | `true` (jika ingin menjalankan `nix flake update`)
*   *Contoh Update Total (Online):* `./scripts/update.sh switch auto true`

### 3. `export-cache.sh`
*   **Argumen 1 (Target Cache):** Path folder tujuan ekspor paket biner.
*   *Catatan:* Jika dikosongkan pada WSL, otomatis akan membuka Windows Explorer dan mengarahkan default ke `/mnt/c/nix-cache`.

### 4. `sync-desktop.sh`
*   **Argumen 1 (IP Target):** IP Komputer Desktop Anda (Default: `192.168.50.2`).
*   **Argumen 2 (User Target):** Username SSH di Desktop (Default: `aurelius`).
*   **Argumen 3 (Source Cache):** Path folder cache asal (Default: deteksi otomatis `/mnt/d/nix-cache` atau lokal `.cache`).

### 5. `apply-offline.sh`
*   **Argumen 1 (Mode):** `switch` (default) | `test` | `boot`
*   **Argumen 2 (Path Cache):** Folder tempat menyimpan biner bursa biner lokal (misal USB drive / mount Windows).

---

## 🔍 Bagian yang Perlu Diedit (Audit Jalur/Paths)

Jika repositori Anda dipindahkan atau setelan jaringan berubah, **buka skrip dan edit baris berikut**:

1. **Nama Folder Repositori (Semua Skrip):**
   Pastikan variabel `CONFIG_DIR` menggunakan huruf kecil/besar yang sama dengan sistem Anda.
   ```bash
   CONFIG_DIR="${HOME}/nixos-config"  # Edit jika nama folder Anda 'NixOS-Config'
   ```

2. **IP Statis & User PC Desktop (`sync-desktop.sh`):**
   Sesuaikan jika IP Router berubah atau mengganti nama user Linux di PC Desktop.
   ```bash
   DESKTOP_IP="${1:-192.168.50.2}"    # Ganti dengan IP lokal Desktop terbaru
   DESKTOP_USER="${2:-aurelius}"      # Ganti sesuai username Desktop Anda
   ```

3. **Nama Target Host Flake (`update.sh` & `apply-offline.sh`):**
   Sesuaikan target bunderan `#nixos` atau `#nixos-wsl` jika Anda mengubah nama konfigurasinya di file `flake.nix`.
   ```bash
   # Pada update.sh
   FLAKE_TARGET="nixos"               # Sesuai dengan konfigurasi di flake.nix
   
   # Pada apply-offline.sh
   sudo nixos-rebuild "$MODE" --flake .#nixos "${EXTRA_FLAGS[@]}"
   ```

---
💡 *Tips Keamanan: Pastikan semua skrip sudah diberikan hak akses eksekusi menggunakan perintah `chmod +x scripts/*.sh` sebelum dijalankan pertama kali.*
