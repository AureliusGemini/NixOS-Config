# Cockpit extensions and add-ons for NixOS
{ config, lib, pkgs, ... }:

{
  # Cockpit Tailscale app (addon)
  # This downloads and installs the cockpit-tailscale app from the official Cockpit project
  systemd.tmpfiles.rules = [
    # Download and extract cockpit-tailscale to /usr/local/share/cockpit-tailscale
    "d /usr/local/share/cockpit-tailscale 0755 root root - -"
  ];

  systemd.services.cockpit-tailscale-install = {
    description = "Install Cockpit Tailscale App";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "/run/current-system/sw/bin/bash" "-c"
        ''
        set -e
        if [ ! -d /usr/local/share/cockpit-tailscale ]; then
          mkdir -p /usr/local/share/cockpit-tailscale
        fi
        cd /usr/local/share/cockpit-tailscale
        curl -fsSL https://github.com/cockpit-project/cockpit-tailscale/releases/latest/download/cockpit-tailscale.tar.xz | tar xJf - --strip-components=1
        ''
      ];
      RemainAfterExit = true;
    };
  };

  # Make Cockpit aware of the extension
  environment.variables = {
    COCKPIT_PLUGIN_PATH = "/usr/local/share/cockpit-tailscale";
  };
}
