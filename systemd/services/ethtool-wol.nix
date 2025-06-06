# Networking module
{ config, lib, pkgs, ... }:

{
  # Enable Wake-on-LAN (WOL) for network interface
  systemd.services."ethtool-wol" = {
    description = "Enable Wake-on-LAN on enp4s0";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [ "${pkgs.ethtool}/bin/ethtool -s enp4s0 wol g" ];
    };
  };
}

# This service enables Wake-on-LAN (WOL) on the network interface enp4s0.
# It uses the ethtool command to set the WOL option to 'g', which allows the system to wake up from a low power state when it receives a magic packet.
# The service is configured to run once at system startup and is part of the multi-user target.
# Make sure to replace 'enp4s0' with your actual network interface name if it's different.
# To apply this configuration, you would typically include it in your NixOS configuration file and rebuild your system.
# After applying, you can check the WOL status with `ethtool enp4s0` to confirm that WOL is enabled.        