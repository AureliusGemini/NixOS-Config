# Desktop user environment: shared modules + the features this machine uses.
{ pkgs, ... }:

{
  imports = [ ./default.nix ];

  my.obs.enable = true;
  my.vscode.enable = true;
  my.apps.enable = true;
  my.gameLaunchers.enable = true;

  my.programs.kate = {
    enable = true;
    plugins = [ pkgs.kate-discord-rpc ]; # from the overlay in flake.nix
    settings = {
      "General" = {
        "Animate Bracket Matching" = true;
      };
    };
    sessionSettings = {
      "Kate Plugins" = {
        "kate-discord-rpcplugin" = true;
      };
    };
  };
}
