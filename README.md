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

### Laptop Host (`nixosConfigurations.nixos-wsl`)
- **Model:** Lenovo ThinkPad Yoga X380
- **CPU:** Intel Core i7-8550U (4C/8T @ 1.80 GHz)
- **RAM:** 16 GB DDR4
- **Host OS:** Windows 11 (WSL2)
- **Guest System:** NixOS 26.11 (Zokor) on `6.18.33.2-microsoft-standard-WSL2`
- **WSL Networking:** Mirrored mode (`eth0` host Wi-Fi, `eth2` Tailscale, `eth3` USB tethering)
- **`%USERPROFILE%\\.wslconfig`:**
  - `processors=6`
  - `memory=6GB`
  - `swap=4GB`
  - `networkingMode=Mirrored`
  - `sparseVhd=true`

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

Example:
```bash
nix copy --substituter-info --to "ssh-ng://aurelius@192.168.50.2" /mnt/d/nix-cache/*
```

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
4. Use phone tethering only for lightweight metadata operations

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

```text
~/nixos-config/
├── flake.nix                          # Flake inputs and outputs
├── flake.lock                         # Locked dependency revisions
├── hosts/
│   ├── desktop/
│   │   ├── configuration.nix          # Desktop NixOS config
│   │   └── hardware-configuration.nix # Desktop hardware config
│   └── wsl/
│       └── configuration.nix          # NixOS-WSL host config
├── modules/
│   └── home/
│       ├── home.nix                   # Desktop user Home Manager config
│       ├── home-wsl.nix               # WSL user Home Manager config
│       └── kate.nix                   # Custom KDE Kate module
├── pkgs/
│   ├── kate-discord-rpc.nix           # Custom Kate Discord RPC derivation
│   └── obs-aitum-vertical.nix         # Custom OBS Vertical Canvas derivation
├── scripts/
│   ├── rebuild.sh                     # Build/apply helper script
│   └── update.sh                      # Update/apply helper script
└── README.md
```
