# my.asf.enable: ArchiSteamFarm container (web UI on localhost:1242).
{ config, lib, ... }:

let
  cfg = config.my.asf;
in
{
  options.my.asf.enable = lib.mkEnableOption "ArchiSteamFarm container";

  config = lib.mkIf cfg.enable {
    my.podman.enable = lib.mkDefault true;

    # TODO: pin the image to a version tag instead of :latest.
    virtualisation.oci-containers.containers.asf = {
      image = "ghcr.io/justarchinet/archisteamfarm:latest";
      autoStart = true;
      # Bound to 127.0.0.1 so it is NOT reachable from campus Wi-Fi / LAN.
      ports = [ "127.0.0.1:1242:1242" ];
      volumes = [ "asf-config:/app/config" ];
      environment = {
        # Must listen on 0.0.0.0 *inside* the container for the port mapping
        # to work; exposure is limited by the 127.0.0.1 host binding above.
        ASF_IPC_IPCADDRESSES = "http://0.0.0.0:1242";
      };
    };
  };
}
