{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager = {
    enable = true;
    extraConfig = "
      [connectivity]
      # Uses Cloudflare's ultra-fast local edge (SG/Jakarta POP)
      uri=http://cp.cloudflare.com/generate_204
      interval=5
      ";
    };
  networking.hostName = "nixos";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  
  services.desktopManager.plasma6.enableQt5Integration = true;
  security.pam.services.sddm.enableKwallet = true;

  time.timeZone = "Asia/Jakarta";

  security.sudo.wheelNeedsPassword = false;
  users.users.aurelius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    description = "AureliusGemini";
  };

  # Enable Gamescope (gives it permissions for realtime scheduling / performance)
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    git
    qpwgraph
    pavucontrol
    vim
    wget
    kdePackages.plasma-integration
    waydroid-helper

    # --- Gaming Tools & Utilities ---
    vulkan-tools
    wineWow64Packages.stableFull # Standard Wine fallback for system integrations
    mangohud
    gamescope              # Valve micro-compositor
    goverlay               # GUI configurator for MangoHud

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-aitum-multistream
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    })
  ];

  services.flatpak = {
    enable = true;
    update.onActivation = true; # Automatically updates flatpaks on rebuild
    remotes = [
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = [
      "org.vinegarhq.Sober"
    ];
  };

  virtualisation.waydroid.enable = true;
  networking.nftables.enable = true;
  networking.firewall.checkReversePath = false;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 8192;
  } ];

  fileSystems."/mnt/storage" = {
    device = "/dev/bcache0"; # Or replace with "/dev/disk/by-uuid/YOUR-UUID" (Recommended)
    fsType = "btrfs";        # Change to "ext4" if you didn't format it as Btrfs
    options = [ "defaults" "nofail" "x-udisks-internal" "compress=zstd" ];
  };

  system.stateVersion = "26.05";
}
