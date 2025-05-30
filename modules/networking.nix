# Networking module
{ config, lib, pkgs, ... }:

{
  # Network configuration
  networking = {
    # Enable NetworkManager
    networkmanager.enable = true;
    
    # IP forwarding
    firewall.enable = false;
  };

  # IP forwarding for Tailscale
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
    "net.ipv6.conf.all.forwarding" = "1";
  };

  # Tailscale
  services.tailscale = {
    enable = true;
  };

  # UDP GRO for network performance
  systemd.services."ethtool-gro" = {
    description = "Enable UDP GRO Forwarding on enp4s0";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "${pkgs.ethtool}/bin/ethtool -K enp4s0 gro on" ];
    };
  };

  # Wake-on-LAN (WOL) enable on enp4s0
  systemd.services."ethtool-wol" = {
    description = "Enable Wake-on-LAN on enp4s0";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "${pkgs.ethtool}/bin/ethtool -s enp4s0 wol g" ];
    };
  };
}
