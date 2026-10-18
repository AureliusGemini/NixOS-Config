# Hostname, NetworkManager, Tailscale, SSH, firewall.
{ ... }:

{
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

  services.tailscale.enable = true;

  # Remote VS Code / terminal access + `nixos-rebuild --target-host`.
  # Put your public keys in `user.sshKeys` in flake.nix.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.nftables.enable = true;
  networking.firewall.checkReversePath = false;
}
