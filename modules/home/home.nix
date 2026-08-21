{ config, pkgs, ... }:

{
  imports = [ ./kate.nix ];

  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  home.sessionVariables = {
    # This forces all launchers to look at Steam's custom tool folder
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
  };

  home.packages = with pkgs; [
    (discord.override { withVencord = true; })

    protonup-qt
    protontricks
    lutris
    heroic
    faugus-launcher

    opencode-desktop

    nixd
    nixfmt
    bash-language-server
    shellcheck
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      # ms-vscode.cpptools
      leonardssh.vscord
    ];
    profiles.default.userSettings = {
      "update.mode" = "none";
      "telemetry.telemetryLevel" = "off";
      "window.titleBarStyle" = "custom";

      # Configure nix-ide to use nixd and nixfmt
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixfmt";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
    };
  };

  # Kate configuration via new module
  programs.kate = {
    enable = true;
    plugins = [
      (pkgs.callPackage ./pkgs/kate-discord-rpc.nix { })
    ];
    settings = {
      "General" = {
        "Animate Bracket Matching" = true;
      };
      "Kate Plugins" = {
        "kate-discord-rpcplugin" = true;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "AureliusGemini";
      user.email = "93374856+AureliusGemini@users.noreply.github.com";
    };
  };

  home.stateVersion = "26.05";
}
