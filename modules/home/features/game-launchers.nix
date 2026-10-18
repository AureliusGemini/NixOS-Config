# my.gameLaunchers.enable: Lutris, Heroic, ProtonUp-Qt and friends.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.gameLaunchers;
in
{
  options.my.gameLaunchers.enable = lib.mkEnableOption "game launchers and Proton tooling";

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
    };

    home.packages = with pkgs; [
      r2modman
      protonup-qt
      protontricks
      lutris
      heroic
      faugus-launcher
    ];
  };
}
