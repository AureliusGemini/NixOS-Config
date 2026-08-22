# ~/nixos-config/modules/home/kate.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kate;
in {
  options.programs.kate = {
    enable = mkEnableOption "Kate text editor configuration";

    package = mkPackageOption pkgs.kdePackages "kate" { };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of Kate plugin packages to install.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration settings written directly to ~/.config/katerc.";
    };

    sessionSettings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Session settings written to ~/.local/state/kate/anonymous.katesession.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.plugins;

    xdg.configFile."katerc".text = generators.toINI { } cfg.settings;

    xdg.stateFile."kate/anonymous.katesession".text =
      generators.toINI { } cfg.sessionSettings;
  };
}
