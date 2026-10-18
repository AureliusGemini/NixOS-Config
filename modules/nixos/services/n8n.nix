# my.n8n.enable: n8n workflow automation container (localhost:5678).
{ config, lib, ... }:

let
  cfg = config.my.n8n;
in
{
  options.my.n8n.enable = lib.mkEnableOption "n8n container";

  config = lib.mkIf cfg.enable {
    my.podman.enable = lib.mkDefault true;

    # TODO: pin the image to a version tag instead of :latest.
    virtualisation.oci-containers.containers.n8n = {
      image = "docker.io/n8nio/n8n:latest";
      autoStart = true;
      ports = [ "127.0.0.1:5678:5678" ];
      volumes = [ "n8n-data:/home/node/.n8n" ];
      environment = {
        N8N_PORT = "5678";
        GENERIC_TIMEZONE = "Asia/Jakarta";
      };
    };
  };
}
