{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./router-share.nix # <--- Modul router & share yang dipisah
  ];

  # Nix Settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel module parameters for Realtek Wi-Fi stability & HD-Audio pin probing
  boot.extraModprobeConfig = ''
    options rtl8188ee fwlps=N ips=N aspm=0
    options snd-hda-intel model=auto
  '';

  # Networking Core
  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    settings = {
      connectivity = {
        uri = "http://networkcheck.kde.org";
        interval = 60;
      };
    };
  };
  networking.nftables.enable = true;
  networking.firewall.checkReversePath = false;

  # Enable Tailscale mesh network daemon
  services.tailscale.enable = true;

  # Enable OpenSSH daemon for remote VS Code / terminal access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Hardware & Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Class = "0x000100";
        Enable = "Source,Sink,Media,Socket";
        ControllerMode = "dual";
        Experimental = true;
      };
    };
  };

  # Audio (Pipewire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Graphics Hardware Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Steam & Gaming Integrations
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Desktop Environment (KDE Plasma 6 on SDDM)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  security.pam.services.sddm.enableKwallet = true;

  # User & Localization
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

  # Dynamic linker helper for unpatched binaries / game tools
  programs.nix-ld.enable = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    qpwgraph
    pavucontrol
    vim
    wget
    waydroid-helper
    android-tools
    droidcam

    # --- Gaming Tools & Utilities ---
    vulkan-tools
    wineWow64Packages.stableFull
    mangohud
    goverlay

    pciutils
  ];

  # Flatpak Integration
  services.flatpak = {
    enable = true;
    update.onActivation = true;
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

  # Swap Configuration
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192;
    }
  ];

  # Btrfs File System Configuration
  fileSystems."/".options = [ "subvol=@" "compress=zstd" ];
  fileSystems."/nix".options = [ "subvol=@nix" "compress=zstd" ];
  fileSystems."/home".options = [ "subvol=@home" "compress=zstd" ];

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

  system.stateVersion = "26.05";
}
