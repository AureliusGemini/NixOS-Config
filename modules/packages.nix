# System packages
{ config, lib, pkgs, ... }:

{
  # Essential programs
  programs = {
    firefox.enable = true;
    nix-ld.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    # Development tools
    git
    nix-ld
    
    # System tools
    ethtool
    home-manager
    
    # Applications
    discord
    steam
    zoom-us
    
    # Cockpit dependencies
    sscg

    remmina         # GUI RDP client, works on X11 and Wayland
    freerdp         # Command-line RDP client (xfreerdp)

  ];
}
