<!-- ~/nixos-config/README.md -->
# NixOS Flake Configuration

Declarative NixOS and Home Manager configuration for an AMD Desktop workstation, optimized for gaming, content creation, and development.

---

## System & Hardware Overview

- **CPU:** AMD Ryzen 5 3600 (6 Cores, 12 Threads @ 3.6 GHz)
- **GPU:** AMD Radeon RX 6600 8GB (Mesa RADV with Resizable BAR / SAM Enabled)
- **Motherboard:** Gigabyte B450M DS3H-CF
- **RAM:** 16 GB DDR4
- **Desktop Environment:** KDE Plasma 6 (Wayland) + SDDM
- **Audio:** PipeWire & WirePlumber (low-latency RTKit enabled)
- **Storage:** 
  - **OS Drive (240GB SSD):** Btrfs (`/`, `/nix`, `/home` with `compress=zstd`)
  - **Game & Media Pool:** `bcache0` (480GB SSD cache in `writethrough` mode + 1TB HDD)

---

## Key Features & Stack

- **Declarative Package Management:** Nix Flakes with Home Manager integration (`nixosConfigurations.nixos`).
- **Gaming Stack:** 
  - Steam (32-bit & 64-bit Vulkan/RADV, Valve Fossilize caching)
  - Lutris & Heroic Games Launcher (Legendary & GOGDL)
  - Gamescope & GameMode
  - MangoHud & GOverlay
  - Proton-GE & UMU-Proton custom runner paths
- **Streaming & Recording:** OBS Studio with hardware-accelerated VA-API, PipeWire audio routing, and Aitum Multistream/Vertical plugins.
- **Development & Tools:** VS Code (configured via Home Manager with `nixd` LSP and formatting), KDE Kate (with custom Discord RPC), and dynamic linking support via `nix-ld`.
- **Flatpak Integration:** Declarative Flatpaks (`declarative-flatpak` / `nix-flatpak`) for sandboxed apps (Sober, Modrinth).

---

## Repository Structure

```text
~/nixos-config/
├── flake.nix                          # Flake inputs & system/home outputs
├── flake.lock                         # Locked dependency versions
├── hosts/
│   └── desktop/
│       ├── configuration.nix          # Core NixOS system configuration & drivers
│       └── hardware-configuration.nix # Auto-generated hardware and partition declarations
├── modules/
│   └── home/
│       ├── home.nix                   # User packages, environment variables, & dotfiles
│       └── kate.nix                   # Custom declarative module for KDE Kate
├── pkgs/
│   ├── kate-discord-rpc.nix           # Custom derivation for Kate Discord Rich Presence
│   └── obs-aitum-vertical.nix         # Custom derivation for OBS Vertical Canvas plugin
├── scripts/
│   └── rebuild.sh                     # Automated build, format, commit, and GC helper
└── README.md
