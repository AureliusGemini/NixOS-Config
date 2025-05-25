# Essential system settings
{ config, lib, pkgs, ... }:

{
  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Time zone and locale settings
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";
  
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}
