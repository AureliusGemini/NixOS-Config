# /etc/nixos/services/xrdp.nix
{ config, pkgs, lib, ... }:

{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "plasma";
  };
  # services.xrdp-sesman.enable = true;

  services = {
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
  };
}
