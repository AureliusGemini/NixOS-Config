{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
    package = pkgs.flatpak;
  };
}