# /etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    vscode
    bash
    curl
    git
    gnutar # cuz "tar" doesn't exist
    unzip
    oh-my-posh
    which
    gsmartcontrol
    # and possibly:
    nodejs
    python3
    tailscale-systray
  ];

  # Options
  imports = [
    # Installer Generated
    ./PC/configuration.nix

    # Services
    ./services/ssh.nix
    ./services/xrdp.nix
    ./services/tailscale.nix
    ./services/headscale.nix

    # Programs
    ./programs/nix-ld.nix
    ./minecraft-server.nix 

    # Networking
    ./networking/firewall.nix
    ./systemd/services/ethtool-wol.nix
  ];

  services.flatpak.enable = true;

}
