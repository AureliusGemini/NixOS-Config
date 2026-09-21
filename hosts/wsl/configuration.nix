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
  programs.nix-ld.enable = true;

  users.users.aurelius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    description = "AureliusGemini";
  };

  security.sudo.wheelNeedsPassword = false;
  
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;         # Creates the docker alias and socket
    defaultNetwork.settings = {
    dns_enabled = true;
    };
  };
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  system.stateVersion = "26.05";
}
