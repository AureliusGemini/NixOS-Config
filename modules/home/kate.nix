{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kate;

  # Local package derivation for the Discord RPC plugin
  kateDiscordRpcPkg = pkgs.callPackage ../../pkgs/kate-discord-rpc.nix { };
in {
  options.programs.kate = {
    enable = mkEnableOption "Kate text editor configuration";

    enableDiscordRpc = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to build, install, and enable the Discord RPC plugin for Kate.";
    };

    package = mkPackageOption pkgs.kdePackages "kate" { };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Configuration settings written directly to ~/.config/katerc.";
    };
  };

  config = mkIf cfg.enable {
    # If enableDiscordRpc is true, Nix installs the plugin binary into the environment
    home.packages = [ cfg.package ]
      ++ (lib.optional cfg.enableDiscordRpc kateDiscordRpcPkg);

    xdg.configFile."katerc".text = generators.toINI { } (
      recursiveUpdate cfg.settings {
        "Kate Plugins" = {
          "kate-discord-rpcplugin" = cfg.enableDiscordRpc;
        };
      }
    );
  };
}
