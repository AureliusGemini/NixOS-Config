# /etc/nixos/services/xrdp.nix
{ config, pkgs, lib, ... }:

{
  services.xrdp = {
    enable = true;
    # package = pkgs.xrdp;
    # port = 3389;

    # Audio support
    audio = {
      enable = false;
      # package = pkgs.pulseaudio;
    };

    # SSL configuration
    # sslKey = "/etc/xrdp/key.pem";
    # sslCert = "/etc/xrdp/cert.pem";

    # Firewall
    # openFirewall = true;

    # Optional configuration
    # extraConfDirCommands = ''
    #   echo "Custom config" > /etc/xrdp/custom.conf
    # '';
    # defaultWindowManager = "startxfce4";
  };
}
