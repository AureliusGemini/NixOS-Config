# WSL2 laptop host (ThinkPad X380).
# This file only holds WSL settings and feature toggles. Shared modules live in
# modules/nixos/ (the containers are in modules/nixos/services/).
{ pkgs, user, ... }:

{
  system.stateVersion = "26.05";

  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    defaultUser = user.name;
  };

  # Raise inotify limit so VS Code doesn't lag/spin scanning big projects
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # ---- Services that travel with the laptop ----
  my.podman.enable = true;
  my.asf.enable = true;
  my.n8n.enable = true;
  my.fgc.enable = true;

  # Global toolchains. (Idea for later: move these into per-project devShells.)
  environment.systemPackages = with pkgs; [
    gcc
    python3
    nodejs
    go
    ripgrep
  ];
}
