# ArchiSteamFarm NixOS module (fully migrated to Nix format)
{ config, lib, pkgs, ... }:

{
  services.archisteamfarm = {
    enable = true;
    dataDir = "/opt/archisteamfarm";
    web-ui.enable = true;
    bots = {
      Main = {
        enabled = true;
        username = "AureliusGemini";
        passwordFile = "/opt/archisteamfarm/Main.password";
        settings = {
          # Example settings migrated from Main.json
          # SteamParentalCode = "YOUR_PARENTAL_CODE";
          # CustomGamePlayedWhileFarming = "Half-Life";
          # Add more settings as needed from your Main.json (except password)
        };
      };
      Alt = {
        enabled = true;
        username = "NetherStarG";
        passwordFile = "/opt/archisteamfarm/Alt.password";
        settings = {
          # Example settings migrated from Alt.json
          # SteamParentalCode = "YOUR_PARENTAL_CODE";
          # Add more settings as needed from your Alt.json (except password)
        };
      };
    };
    # Optionally, add global ASF settings here
    settings = {
      # Example: "SteamOwnerID" = "YOUR_STEAM_ID";
    };
  };
}
