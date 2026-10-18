# my.podman.enable: Podman only (no Docker). `docker` is just an alias to podman.
#
# my.podman.graphRoot: where images/layers live. Leave null to use the default
# (/var/lib/containers/storage). The desktop points it at /mnt/homelab.
# Changing it does NOT migrate existing images; re-pull them (see docs/HOMELAB.md).
{ config, lib, user, ... }:

let
  cfg = config.my.podman;
in
{
  options.my.podman = {
    enable = lib.mkEnableOption "Podman (rootful) with OCI container support";
    graphRoot = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/mnt/homelab/containers/storage";
      description = "Container image/layer storage location (null = default).";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      # Prune dangling images only. Do NOT add "--all": it would also delete
      # images of stopped containers (e.g. fgc) and force a re-download.
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.oci-containers.backend = "podman";

    users.users.${user.name}.extraGroups = [ "podman" ];

    environment.sessionVariables = {
      CONTAINER_HOST = "unix:///run/podman/podman.sock";
      DOCKER_HOST = "unix:///run/podman/podman.sock";
    };

    # If the NixOS defaults clash with these, wrap the values in lib.mkForce.
    virtualisation.containers.storage.settings.storage = lib.mkIf (cfg.graphRoot != null) {
      driver = "overlay";
      graphroot = cfg.graphRoot;
      runroot = "/run/containers/storage";
    };

    # Never start a container while the storage disk is not mounted
    # (otherwise it would silently fall back to the root SSD).
    systemd.services = lib.mkIf (cfg.graphRoot != null) (
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair "podman-${name}" {
          unitConfig.RequiresMountsFor = [ cfg.graphRoot ];
        }
      ) config.virtualisation.oci-containers.containers
    );
  };
}
