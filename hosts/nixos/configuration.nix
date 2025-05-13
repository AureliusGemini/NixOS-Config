# Main system configuration
{ config, lib, pkgs, ... }:

{
  imports = [
    # Hardware configuration
    ./hardware-configuration.nix
    
    # Modules
    ../../modules/essentials.nix
    ../../modules/networking.nix
    ../../modules/desktop.nix
    ../../modules/packages.nix
    ../../modules/virtualization.nix
    ../../modules/cockpit-extensions.nix
    ../../modules/archisteamfarm.nix
    
    # Users
    ../../users/aurelius.nix
  ];

  # System hostname
  networking.hostName = "nixos";

  # Enable Cockpit web console
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.11"; # Did you read the comment?
}
