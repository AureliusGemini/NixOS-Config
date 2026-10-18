# Home Manager config shared by desktop + WSL.
# (home.username / home.homeDirectory are derived automatically from the
#  NixOS user, so they are not set here.)
{ ... }:

{
  imports = [
    ./git.nix
    ./dev-tools.nix
    ./lazygit.nix
  ];

  home.stateVersion = "26.05";
}
