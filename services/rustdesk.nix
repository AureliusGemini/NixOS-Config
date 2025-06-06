# /etc/nixos/services/rustdesk.nix
{ config, pkgs, ... }:

{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    package = pkgs.rustdesk-server;
    relay = {
      enable = true;
      # extraArgs = [ "--relay-hosts=relay1.example.com,relay2.example.com" ];
    };
    signal = {
      enable = true;
      # extraArgs = [ "--relay-hosts=signal1.example.com,signal2.example.com" ];
      # relayHosts = [ "signal1.example.com" "signal2.example.com" ];
    };
  };
}