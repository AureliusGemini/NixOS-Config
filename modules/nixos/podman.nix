# ~/nixos-config/modules/nixos/podman.nix
{ config, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Maps 'docker' CLI commands to podman
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      n8n = {
        image = "docker.io/n8nio/n8n:latest";
        ports = [ "5678:5678" ];
        environment = {
          GENERIC_TIMEZONE = "Asia/Jakarta";
          TZ = "Asia/Jakarta";
        };
        volumes = [
          "n8n_data:/home/node/.n8n"
        ];
      };

      asf = {
        image = "docker.io/justkey233/archisteamfarm:latest";
        ports = [ "1242:1242" ];
        volumes = [
          "/var/lib/asf/config:/app/config"
          "/var/lib/asf/plugins:/app/plugins"
        ];
      };

      free-games-claimer = {
        image = "docker.io/vogler/free-games-claimer:latest";
        volumes = [
          "/var/lib/free-games-claimer/data:/app/data"
        ];
        environment = {
          NOTIFY = "false";
        };
      };
    };
  };
}
