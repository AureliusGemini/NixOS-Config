{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager = {
    enable = true;
    settings = {
      connectivity = {
        uri = "http://networkcheck.kde.org";
        interval = 5;
      };
    };
  };
  networking.hostName = "nixos";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # 0x000104 = Computer / Desktop Workstation
        Class = "0x000104";
        # Enables Headset/Handsfree profiles along with standard audio
        Enable = "Source,Sink,Media,Socket";
        ControllerMode = "dual";
        Experimental = true;
      };
    };
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
    extraGroups = [
      "wheel"
      "networkmanager"
      "adbusers"
    ];
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
    android-tools
    droidcam

    # --- Gaming Tools & Utilities ---
    vulkan-tools
    wineWow64Packages.stableFull # Standard Wine fallback for system integrations
    mangohud
    goverlay # GUI configurator for MangoHud

    (wrapOBS {
      plugins = with obs-studio-plugins; [
        obs-aitum-multistream
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
        droidcam-obs
      ];
    })

    pciutils
  ];

  services.flatpak = {
    enable = true;
    update.onActivation = true; # Automatically updates flatpaks on rebuild
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "org.vinegarhq.Sober"
      "com.modrinth.ModrinthApp"
    ];
  };

  virtualisation.waydroid.enable = true;
  networking.nftables.enable = true;
  networking.firewall.checkReversePath = false;

  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192;
    }
  ];

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/5a1c9e0a-cafd-4f46-a596-f33e7abd9387";
    fsType = "btrfs";
    options = [
      "defaults"
      "nofail"
      "x-udisks-internal"
      "compress=zstd"
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit Steam games
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  system.stateVersion = "26.05";
}
