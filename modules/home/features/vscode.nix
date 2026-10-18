# my.vscode.enable: VS Code with nixd + Nix formatting.
{ config, lib, pkgs, ... }:

let
  cfg = config.my.vscode;
in
{
  options.my.vscode.enable = lib.mkEnableOption "VS Code";

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.override {
        commandLineArgs = "--password-store=basic";
      };
      profiles.default.extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        leonardssh.vscord
        pkief.material-icon-theme
      ];
      profiles.default.userSettings = {
        "update.mode" = "none";
        "telemetry.telemetryLevel" = "off";
        "window.titleBarStyle" = "custom";
        "workbench.iconTheme" = "material-icon-theme";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "options" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
