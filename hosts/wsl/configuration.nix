{ pkgs, ... }:

{
  networking.hostName = "nixos-wsl";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "@wheel" ];

  # 1. WSL System Integration
  wsl = {
    enable = true;
    defaultUser = "aurelius";
  };
  
  programs.nix-ld.enable = true;

  # 2. Kernel Optimization for Coding Performance
  # Menaikkan inotify limit agar VS Code tidak lag/high-CPU saat memindai file proyek besar
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };

  # 3. User Accounts Configuration
  users.users.aurelius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    description = "AureliusGemini";
    # UID/GID mapping krusial agar container rootless Podman berjalan efisien tanpa lag
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startUid = 100000; count = 65536; }];
  };

  security.sudo.wheelNeedsPassword = false;
  
  environment.sessionVariables = {
    CONTAINER_HOST = "unix:///run/podman/podman.sock";
    DOCKER_HOST = "unix:///run/podman/podman.sock";
  };
  
  # 4. Podman Engine Configuration
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  # 5. Declarative OCI Container Services
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {

      # --- Vogler Free Games Claimer (FGC) ---
      fgc = {
        image = "ghcr.io/vogler/free-games-claimer:latest";
        autoStart = false;
        ports = [
          "6080:6080" # noVNC Web UI (Access via http://localhost:6080)
        ];
        volumes = [
          "fgc-data:/fgc/data"
        ];
        # Note: Jika CPU masih sering spike, ubah autoStart ke false agar container ini dijalankan manual saat ingin berkala saja.
        cmd = [ "bash" "-c" "node epic-games.js; node gog.js" ];
      };

      # --- ArchiSteamFarm (ASF) ---
      asf = {
        image = "ghcr.io/justarchinet/archisteamfarm:latest";
        autoStart = true;
        ports = [
          "1242:1242"
        ];
        volumes = [
          "asf-config:/app/config"
        ];
        environment = {
          ASF_IPC_IPCADDRESSES = "http://0.0.0.0:1242";
        };
      };

      # --- n8n Workflow Automation ---
      n8n = {
        image = "docker.io/n8nio/n8n:latest"; 
        autoStart = true;
        ports = [ "5678:5678" ];
        volumes = [ "n8n-data:/home/node/.n8n" ];
        environment = {
          N8N_PORT = "5678";
          GENERIC_TIMEZONE = "Asia/Jakarta";
        };
      };

    };
  };

  # 6. Global System Packages
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
