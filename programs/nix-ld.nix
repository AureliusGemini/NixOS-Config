# /etc/nixos/programs/nix-ld.nix
{ config, pkgs, lib, ... }:

{
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld; # or a custom one if needed
    libraries = with pkgs; [
      glibc
      zlib
      openssl
      curl
      libssh
      stdenv.cc.cc.lib
      # add more if VS Code errors mention missing libs
    ];
  };
}
