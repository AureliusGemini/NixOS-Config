# my.waydroid.enable: Android container + adb/droidcam tooling.
{ config, lib, pkgs, user, ... }:

let
  cfg = config.my.waydroid;
in
{
  options.my.waydroid.enable = lib.mkEnableOption "Waydroid and Android tooling";

  config = lib.mkIf cfg.enable {
    virtualisation.waydroid.enable = true;

    environment.systemPackages = with pkgs; [
      waydroid-helper
      android-tools
      droidcam
    ];

    # check this group still exists on your nixpkgs
    users.users.${user.name}.extraGroups = [ "adbusers" ];
  };
}
