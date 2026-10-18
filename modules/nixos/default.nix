# Every shared NixOS module. Nothing here does anything until a host turns it
# on with `my.<name>.enable = true;` (core/* is always on).
{ ... }:

{
  imports = [
    ./core/nix.nix
    ./core/user.nix
    ./core/locale.nix
    ./core/base.nix

    ./features/audio.nix
    ./features/bluetooth.nix
    ./features/plasma.nix
    ./features/gaming.nix
    ./features/amd-gpu.nix
    ./features/flatpak.nix
    ./features/waydroid.nix
    ./features/podman.nix

    ./services/asf.nix
    ./services/n8n.nix
    ./services/fgc.nix
    ./services/adguard.nix
  ];
}
