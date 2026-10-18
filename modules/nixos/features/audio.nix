# my.audio.enable: PipeWire stack + patchbay tools.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.audio;
in
{
  options.my.audio.enable = lib.mkEnableOption "PipeWire audio stack";

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    environment.systemPackages = with pkgs; [
      qpwgraph
      pavucontrol
    ];
  };
}
