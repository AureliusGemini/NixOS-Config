# my.plasma.enable: KDE Plasma 6 on SDDM (+ KWallet unlock at login).
{ config, lib, ... }:

let
  cfg = config.my.plasma;
in
{
  options.my.plasma.enable = lib.mkEnableOption "KDE Plasma 6 desktop";

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    security.pam.services.sddm.enableKwallet = true;
  };
}
