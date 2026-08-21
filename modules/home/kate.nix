{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kate;
  kateDiscordRpcPkg = pkgs.callPackage ../../pkgs/kate-discord-rpc.nix { };
in {
  options.programs.kate = {
    enable = mkEnableOption "Kate text editor configuration";

    enableDiscordRpc = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to build, install, and activate the Discord RPC plugin for Kate.";
    };

    package = mkPackageOption pkgs.kdePackages "kate" { };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration settings written directly to ~/.config/katerc.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ]
      ++ (lib.optional cfg.enableDiscordRpc kateDiscordRpcPkg);

    xdg.configFile."katerc".text = generators.toINI { } cfg.settings;

    # Force the plugin state into Kate's default session
    xdg.stateFile."kate/anonymous.katesession".text = generators.toINI { } {
      "Kate Plugins" = {
        "kate-discord-rpcplugin" = cfg.enableDiscordRpc;
      };
    };
  };
}
