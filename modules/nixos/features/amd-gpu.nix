# my.amdGpu.enable: Mesa/RADV + VA-API/VDPAU bits for the RX 6600.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.amdGpu;
  videoPkgs = with pkgs; [
    libva
    libva-vdpau-driver
    libvdpau-va-gl
  ];
in
{
  options.my.amdGpu.enable = lib.mkEnableOption "AMD GPU graphics stack";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = videoPkgs;
      extraPackages32 = videoPkgs;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
