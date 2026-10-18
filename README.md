# NixOS Flake Configuration

Declarative NixOS + Home Manager setup for a desktop and WSL laptop workflow, including offline-first caching for low-connectivity home usage.

---

## Multi-Host Setup

### Desktop Host (`nixosConfigurations.nixos`)
- **Role:** Primary AMD desktop (gaming, creation, daily workstation)
- **CPU:** AMD Ryzen 5 3600 (6C/12T @ 3.6 GHz)
- **GPU:** AMD Radeon RX 6600 8GB (Mesa RADV + SAM/ReBAR)
- **RAM:** 16 GB DDR4
- **Desktop Environment:** KDE Plasma 6 (Wayland) + SDDM
- **Audio:** PipeWire + WirePlumber (RTKit enabled)
- **Storage:**
  - OS SSD (240GB) with Btrfs (`/`, `/nix`, `/home`, `compress=zstd`)
  - Cached game/media pool via `bcache0` (480GB SSD + 1TB HDD)
  - 500GB HDD (`sda`, Btrfs) mounted at `/mnt/homelab` for homelab services + Podman images (see `docs/HOMELAB.md`)

### Laptop Host (`nixosConfigurations.nixos-wsl`)
- **Model:** Lenovo ThinkPad Yoga X380
- **CPU:** Intel Core i7-8550U (4C/8T @ 1.80 GHz)
- **RAM:** 16 GB DDR4
- **Host OS:** Windows 11 (WSL2)
- **Guest System:** NixOS 26.11 (Zokor) on `6.18.33.2-microsoft-standard-WSL2`
- **WSL Networking:** Mirrored mode (`eth0` host Wi-Fi, `eth2` Tailscale, `eth3` USB tethering)
- **`%USERPROFILE%\\.wslconfig` (Optimized for Dev & Podman):**
  ```ini
  [wsl2]
  processors=3          # Teroptimasi: Menggunakan 3 core fisik agar host Windows tidak choking/lag
  memory=6GB            # Alokasi RAM seimbang untuk host 16GB
  swap=4GB              # Buffer tambahan untuk container Podman berat
  networkingMode=Mirrored
  sparseVhd=true        # Otomatis menyusutkan file VHDX saat container/images dihapus

  [experimental]
  autoMemoryReclaim=gradual  # Manajemen RAM pintar tanpa merusak cache compiler VS Code
  ```

---

## Offline-First Update Pipeline

Goal: use strong external internet (campus) for large downloads, then transfer cached Nix store data home without spending mobile data.

### 1) Campus Phase (High-Speed Wi-Fi)
On the ThinkPad (`nixos-wsl`):
- update inputs when intentionally bumping revisions
- pre-download and cache large closures locally (for example `/mnt/d/nix-cache`)

Example:
```bash
nix flake update
nix copy --to "file:///mnt/d/nix-cache" .#nixosConfigurations.nixos.config.system.build.toplevel
```

### 2) Home Transfer Phase (No Home Wi-Fi)
#### Primary: Direct P2P Ethernet (RJ45)
- connect laptop and desktop directly (no router)
- static IP pair example: `192.168.50.1 <-> 192.168.50.2`
- transfer closures over LAN via `ssh-ng://` (or serve via `nix-serve`)

Example (from the laptop, using the helper scripts in `scripts/`):
```bash
./scripts/export-cache.sh /mnt/d/nix-cache   # build + export closure and flake inputs
./scripts/sync-desktop.sh                    # push the closure to the desktop over SSH
```
The desktop's SSH key must be authorised: add the laptop's public key to `user.sshKeys` in `flake.nix`.

#### Fallback: USB Drive
- move cached closures by exFAT/Btrfs USB when cable sync is unavailable

### 3) Mobile Data Use Policy (USB Tethering)
- phone tethering is metadata/light-traffic only:
  - git pull/push
  - small flake lock updates
- avoid heavy package/closure downloads over cellular

### 4) Desktop Consume/Activate
Example rebuild on desktop:
```bash
sudo nixos-rebuild switch --flake .#nixos --option extra-substituters "file:///mnt/usb-cache"
```

---

## Real-Life Scenarios

### University Wi-Fi Day
1. Update and prefetch on laptop (`nixos-wsl`)
2. Store closures on local disk/USB
3. Return home with cache ready

### Home No-Wi-Fi Day
1. Link laptop <-> desktop by direct Ethernet (or USB drive fallback)
2. Transfer/share closures locally
3. Rebuild desktop from local cache
4. Use phone usb tethering only for lightweight metadata operations

---

## Network Topology (ASCII)

```text
            [University Wi-Fi]
                    |
        +---------------------------+

        | Lenovo X380 (Windows+WSL) |
        | nixos-wsl cache producer  |
        +---------------------------+

             |                |
    (USB drive fallback)   (at home: direct RJ45)

             |                |
             +--------+-------+
                      |
        +---------------------------+

        | AMD Desktop (NixOS)       |
        | local cache consumer       |
        +---------------------------+

Phone USB tethering can attach to either machine for light git/metadata traffic.
```

---

## Key Features & Stack

- **Declarative package management:** Nix Flakes + Home Manager
- **Desktop gaming stack:** Steam, Lutris, Heroic, Gamescope, GameMode, MangoHud
- **Streaming/recording:** OBS with VA-API + Aitum plugins
- **Development:** VS Code (`nixd`, formatter), Kate with custom Discord RPC, `nix-ld`
- **Flatpaks:** Declarative via `nix-flatpak`

---

## Repository Structure

Features are toggles: a module under `modules/` does nothing until a host sets
`my.<name>.enable = true;`. Hosts only import host-specific files and flip toggles.

```text
~/nixos-config/
├── flake.nix                     # inputs, `user` (single identity), mkHost, overlay
├── flake.lock
├── hosts/
│   ├── desktop/
│   │   ├── default.nix           # imports + feature toggles
│   │   ├── boot.nix              # bootloader, module quirks
│   │   ├── network.nix           # hostname, NetworkManager, Tailscale, SSH, firewall
│   │   ├── storage.nix           # root btrfs options, /mnt/storage (bcache), swap
│   │   ├── homelab.nix           # /mnt/homelab (sda) + Podman graphRoot
│   │   └── hardware-configuration.nix
│   └── wsl/default.nix           # WSL settings + toggles (podman, asf, n8n, fgc)
├── modules/
│   ├── nixos/
│   │   ├── default.nix           # imports everything below
│   │   ├── core/                 # always on: nix, user, locale, base
│   │   ├── features/             # audio bluetooth plasma gaming amd-gpu flatpak waydroid podman
│   │   └── services/             # asf n8n fgc adguard
│   └── home/
│       ├── default.nix           # imports everything below
│       ├── common/               # git (+gh), dev-tools, lazygit
│       ├── features/             # obs vscode apps game-launchers kate
│       ├── desktop.nix           # toggles for the desktop
│       └── wsl.nix               # toggles for the laptop
├── pkgs/                         # kate-discord-rpc, obs-aitum-vertical (overlay)
├── scripts/                      # see scripts/README.md
└── docs/HOMELAB.md               # one-time homelab/Podman/AdGuard setup
```

Rebuild: `nh os switch` (or `sudo nixos-rebuild switch --flake .`); the host is picked
from `networking.hostName` (`nixos` = desktop, `nixos-wsl` = laptop).
