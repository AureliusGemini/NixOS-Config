# my.gaming.enable: Steam, Gamescope, GameMode, Wine tooling.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;
in
{
  options.my.gaming.enable = lib.mkEnableOption "Steam, Gamescope, GameMode and Wine tooling";

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    hardware.steam-hardware.enable = true;

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    environment.systemPackages = with pkgs; [
      vulkan-tools
      wineWow64Packages.stableFull
      mangohud
      goverlay
    ];
  };
}
