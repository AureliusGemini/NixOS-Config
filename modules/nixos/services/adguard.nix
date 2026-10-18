# my.adguard.enable: AdGuard Home DNS filter, as a native NixOS service
# (not a container, so DNS keeps working even if Podman/the HDD has a problem).
#
# By default it only answers on 127.0.0.1. With no home router/Wi-Fi it can only
# filter this machine (and others you point at it over the cable / Tailscale).
# Set lanDns = true to answer other devices too. See docs/HOMELAB.md.
{ config, lib, ... }:

let
  cfg = config.my.adguard;
in
{
  options.my.adguard = {
    enable = lib.mkEnableOption "AdGuard Home";
    lanDns = lib.mkEnableOption "answer DNS queries from other devices (opens port 53)";
    upstreams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "https://dns.quad9.net/dns-query" ];
      description = "Upstream DNS servers.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      host = "127.0.0.1"; # web UI: http://127.0.0.1:3000
      port = 3000;
      mutableSettings = true; # keep changes made in the web UI
      settings = {
        dns = {
          bind_hosts = if cfg.lanDns then [ "0.0.0.0" ] else [ "127.0.0.1" ];
          upstream_dns = cfg.upstreams;
        };
        querylog = {
          enabled = true;
          interval = "168h"; # keep 7 days of logs
        };
      };
    };

    networking.firewall = lib.mkIf cfg.lanDns {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };

    # If services.resolved is enabled elsewhere, its stub listener also uses
    # port 53; add: services.resolved.extraConfig = "DNSStubListener=no";
  };
}
