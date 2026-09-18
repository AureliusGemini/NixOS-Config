{ pkgs, ... }:

{
  networking.hostName = "nixos-wsl";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  wsl = {
    enable = true;
    defaultUser = "aurelius";
  };

  users.users.aurelius = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "AureliusGemini";
  };

  security.sudo.wheelNeedsPassword = false;

  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  system.stateVersion = "26.05";
}
