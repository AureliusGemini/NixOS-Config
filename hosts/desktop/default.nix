# Desktop host (AMD Ryzen 5 3600 + RX 6600, KDE Plasma 6).
# This file only imports host-specific files and flips feature toggles.
# Shared modules live in modules/nixos/.
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./network.nix
    ./storage.nix
    ./homelab.nix
  ];

  system.stateVersion = "26.05";

  # ---- Features (see modules/nixos/features) ----
  my.audio.enable = true;
  my.bluetooth.enable = true;
  my.plasma.enable = true;
  my.gaming.enable = true;
  my.amdGpu.enable = true;
  my.flatpak.enable = true;
  my.waydroid.enable = true;

  # ---- Services (see modules/nixos/services) ----
  # my.adguard.enable = true;   # off for now; see docs/HOMELAB.md first

  environment.systemPackages = with pkgs; [ pciutils ];
}
