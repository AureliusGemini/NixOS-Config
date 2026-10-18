# my.apps.enable: everyday GUI apps (Discord, Firefox, tray, opencode).
{ config, lib, pkgs, ... }:

let
  cfg = config.my.apps;
in
{
  options.my.apps.enable = lib.mkEnableOption "everyday GUI apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override { withVencord = true; })
      tailscale-systray # tray GUI for KDE Plasma
      opencode-desktop
    ];

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
    };
  };
}
