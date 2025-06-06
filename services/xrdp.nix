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
    defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11"; # or "startxfce4";
  };
  
  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.krdp
    kdePackages.plasma-workspace
    xrdp
  ];

  # security.pam.services.xrdp = {
  #   auth = [ { sufficient = "pam_unix.so"; } ];
  #   session = [ { required = "pam_systemd.so"; } ];
  # };
  
}
