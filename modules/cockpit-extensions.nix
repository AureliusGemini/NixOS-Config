# Cockpit extensions and add-ons for NixOS
{ config, lib, pkgs, ... }:

{
  # Cockpit Tailscale app (from spotsnel/cockpit-tailscale)
  # Disabled for now due to install issues
  # systemd.tmpfiles.rules = [
  #   "d /usr/local/share/cockpit/tailscale 0755 root root - -"
  # ];

  # systemd.services.cockpit-tailscale-install = {
  #   description = "Install Cockpit Tailscale App (spotsnel/cockpit-tailscale)";
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.curl pkgs.gnutar pkgs.gzip ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     ExecStart = "/run/current-system/sw/bin/bash -c 'set -e; if [ ! -d /usr/local/share/cockpit/tailscale ]; then mkdir -p /usr/local/share/cockpit/tailscale; fi; cd /usr/local/share/cockpit/tailscale; curl -fsSL https://github.com/gbraad-cockpit/cockpit-tailscale/releases/download/v0.0.6/cockpit-tailscale-v0.0.6.tar.gz | tar xzf - --strip-components=1'";
  #     RemainAfterExit = true;
  #   };
  # };

  # environment.variables = {
  #   COCKPIT_PLUGIN_PATH = "/usr/local/share/cockpit/tailscale";
  # };
}
