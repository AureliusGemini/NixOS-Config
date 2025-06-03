# /etc/nixos/services/tailscale.nix
{ config, pkgs, lib, ... }:

{
  services = {
    tailscale = {
      enable = true;
      # package = pkgs.tailscale;
      # port = 41641;
      # interfaceName = "tailscale0";
      openFirewall = true;
      # permitCertUid = "1000";

      # Authentication settings
      # authKeyFile = "/etc/nixos/secrets/tailscale-auth.key";
      # authKeyParameters = {
      #   baseURL = "https://example.com";
      #   ephemeral = true;
      #   preauthorized = true;
      # };

      # Routing and advanced features
      # useRoutingFeatures = "both";  # Options: "client", "server", "both"
      # disableTaildrop = true;

      # DERP relay configuration
      derper = {
        enable = false;
        # domain = "derp.example.com";
        # port = 443;
        # stunPort = 3478;
        # package = pkgs.tailscale;
        # verifyClients = true;
        # openFirewall = true;
      };

      # Extra flags
      # extraDaemonFlags = [ "--tun=userspace-networking" ];
      # extraSetFlags = [ ];
      # extraUpFlags = [ "--advertise-exit-node" ];
    };

    tailscaleAuth = {
      enable = false;
      # socketPath = "/run/tailscale-auth.sock";
      # user = "nobody";
      # group = "nogroup";
      # package = pkgs.tailscale;
    };
  };
}
