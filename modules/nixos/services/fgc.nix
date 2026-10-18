# my.fgc.enable: Free Games Claimer container (started manually).
{ config, lib, ... }:

let
  cfg = config.my.fgc;
in
{
  options.my.fgc.enable = lib.mkEnableOption "Free Games Claimer container";

  config = lib.mkIf cfg.enable {
    my.podman.enable = lib.mkDefault true;

    # TODO: pin the image to a version tag instead of :latest.
    virtualisation.oci-containers.containers.fgc = {
      image = "ghcr.io/vogler/free-games-claimer:latest";
      autoStart = false; # run manually when wanted
      ports = [ "127.0.0.1:6080:6080" ]; # noVNC Web UI -> http://localhost:6080
      volumes = [ "fgc-data:/fgc/data" ];
      cmd = [
        "bash"
        "-c"
        "node epic-games.js; node gog.js"
      ];
    };
  };
}
