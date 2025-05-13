# ArchiSteamFarm NixOS module (using native ASF config folder)
{ config, lib, pkgs, ... }:

{
  services.archisteamfarm = {
    enable = true;
    dataDir = "/opt/ArchiSteamFarm";
    web-ui.enable = true;
    # Bots and settings will be loaded from the config files in dataDir/config/
  };
}