# Desktop environment module
{ config, lib, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
#   services.xserver.desktopManager.plasma5.enable = true;

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
#   networking.firewall.allowedTCPPorts = [ 3389 ];


  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  systemd.services.xrdp = {
    enable = true;
    serviceConfig.ExecStart = lib.mkForce "";
  };



  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
  };

}
