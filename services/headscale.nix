# /etc/nixos/services/headscale.nix
{ config, pkgs, lib, ... }:

{
  services.headscale = {
    enable = false;

    settings = {
      # DERP server config
      # derp.paths = [ "/etc/headscale/derp.yaml" ];
      # derp.urls = [ "https://derp.example.com/derp.yaml" ];

      # DNS settings
      # dns = {
      #   nameservers.global = [ "1.1.1.1" "8.8.8.8" ];
      #   search_domains = [ "example.com" ];
      # };

      # IP prefix settings
      # prefixes = {
      #   v4 = [ "100.64.0.0/10" ];
      #   v6 = [ "fd7a:115c:a1e0::/48" ];
      # };
    };
  };
}
