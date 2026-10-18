# Small things every host wants.
{ pkgs, ... }:

{
  programs.git.enable = true;
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];
}
