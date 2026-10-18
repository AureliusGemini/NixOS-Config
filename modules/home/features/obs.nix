# my.obs.enable: OBS Studio with VA-API + Aitum plugins.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.obs;
in
{
  options.my.obs.enable = lib.mkEnableOption "OBS Studio and plugins";

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins =
        (with pkgs.obs-studio-plugins; [
          obs-aitum-multistream
          obs-vaapi
          obs-vkcapture
          obs-pipewire-audio-capture
          droidcam-obs
        ])
        ++ [ pkgs.obs-aitum-vertical ]; # from the overlay in flake.nix
    };
  };
}
