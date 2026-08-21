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
      example = literalExpression ''
        {
          "General" = {
            "Animate Bracket Matching" = true;
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.plugins;

    # Ensure Kate and Qt find plugins installed in user profiles
    home.sessionVariables = {
      QT_PLUGIN_PATH = "$HOME/.nix-profile/lib/qt-6/plugins:$HOME/.nix-profile/lib/plugins:$QT_PLUGIN_PATH";
    };

    xdg.configFile."katerc".text = generators.toINI { } cfg.settings;
  };
}
