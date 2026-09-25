{ pkgs, ... }:

{
  networking.hostName = "nixos-wsl";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "@wheel" ];

  wsl = {
    enable = true;
    defaultUser = "aurelius";
  };
  programs.nix-ld.enable = true;

  users.users.aurelius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    description = "AureliusGemini";
  };

  security.sudo.wheelNeedsPassword = false;
  
  # 1. Podman Configuration
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  # 2. Declarative OCI Container Services
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {

      # --- Vogler Free Games Claimer (FGC) ---
      fgc = {
        image = "ghcr.io/vogler/free-games-claimer:latest";
        autoStart = true;
        ports = [
          "6080:6080" # noVNC Web UI (Access via http://localhost:6080)
        ];
        volumes = [
          "fgc-data:/fgc/data"
        ];
        # Prime Gaming DISABLED: Executing Epic Games and GOG only
        cmd = [ "bash" "-c" "node epic-games.js; node gog.js; echo 'Sleeping for 1 day'; sleep 1d" ];
      };

      # --- ArchiSteamFarm (ASF) ---
      asf = {
        image = "ghcr.io/justarchinet/archisteamfarm:latest";
        autoStart = true;
        ports = [
          "1242:1242" # ASF IPC Web Interface
        ];
        volumes = [
          "asf-config:/app/config"
        ];
      };

      # --- n8n Workflow Automation ---
      n8n = {
        image = "docker.n8n.io/n8nio/n8n:latest";
        autoStart = true;
        ports = [
          "5678:5678" # n8n Web UI (Access via http://localhost:5678)
        ];
        volumes = [
          "n8n-data:/home/node/.n8n"
        ];
        environment = {
          N8N_PORT = "5678";
          GENERIC_TIMEZONE = "Asia/Jakarta";
        };
      };

    };
  };

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    gcc
    python3
    nodejs
    go
    ripgrep
  ];

  system.stateVersion = "26.05";
}