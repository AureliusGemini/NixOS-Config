# my.flatpak.enable: declarative Flatpaks via nix-flatpak.
# The nix-flatpak module is imported here (not in flake.nix) because options
# from an un-imported module cannot be referenced, even under mkIf false.
{ config, lib, inputs, ... }:

let
  cfg = config.my.flatpak;
in
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  options.my.flatpak.enable = lib.mkEnableOption "Flatpak with declarative packages";

  config = lib.mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      # false: don't hit Flathub on every rebuild (offline-first workflow).
      update.onActivation = false;
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
  };
}
