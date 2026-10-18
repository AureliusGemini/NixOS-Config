# my.bluetooth.enable
{ config, lib, ... }:

let
  cfg = config.my.bluetooth;
in
{
  options.my.bluetooth.enable = lib.mkEnableOption "Bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          # Class set to Computer (0x000100) instead of Car Audio (0x000104)
          Class = "0x000100";
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "dual";
          Experimental = true;
        };
      };
    };
  };
}
