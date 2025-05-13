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
    virtualbox
    steam
    
    # Cockpit dependencies
    sscg
  ];
}
