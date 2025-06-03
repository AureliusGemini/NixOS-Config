# /etc/nixos/networking/firewall.nix
{ config, pkgs, lib, ... }:

{
  networking.firewall = {
    enable = false;
    package = pkgs.iptables;  # Specify the firewall package to use
    allowedTCPPorts = [ 22 80 443 ];  # Allow SSH, HTTP, and HTTPS ports
    allowedUDPPorts = [ 53 ];  # Allow DNS queries

    # Define port ranges for specific applications
    allowedTCPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];

    # Enable ping responses
    allowPing = true;

    # Enable reverse path filtering
    checkReversePath = true;

    # Enable logging of dropped packets
    logReversePathDrops = true;

    # Define trusted interfaces
    trustedInterfaces = [ "lo" ];

    # Additional custom firewall commands
    extraCommands = ''
      # Example: Allow incoming traffic on port 8080
      ip6tables -A INPUT -p tcp --dport 8080 -j ACCEPT
    '';

    # Commands to run when stopping the firewall
    extraStopCommands = ''
      # Example: Flush all iptables rules
      iptables -F
    '';
  };
}
