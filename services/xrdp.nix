# /etc/nixos/services/xrdp.nix
{ config, pkgs, lib, ... }:

{
  services.xrdp = {
    enable = true;
    package = pkgs.xrdp;

    # Audio support
    audio = {
      enable = true;
      package = pkgs.pulseaudio;
    };

    # SSL configuration
    # sslKey = "/etc/xrdp/key.pem";
    # sslCert = "/etc/xrdp/cert.pem";

    # Firewall
    # port = 3389;
    openFirewall = true;

    # Optional configuration
    # extraConfDirCommands = ''
    #   echo "Custom config" > /etc/xrdp/custom.conf
    # '';
    defaultWindowManager = "startplasma-x11";  
  };
  
  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.krdp
    kdePackages.plasma-workspace
    xrdp
  ];

}
