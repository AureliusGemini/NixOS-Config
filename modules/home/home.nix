{ config, pkgs, ... }:

let
  obs-aitum-vertical = pkgs.callPackage ../../pkgs/obs-aitum-vertical.nix { };
in
{
  imports = [
    ./kate.nix
  ];

  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  home.sessionVariables = {
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

  programs.obs-studio = {
    enable = true;
    plugins = (with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
      wlrobs
      obs-vaapi
      obs-vkcapture
      obs-pipewire-audio-capture
      droidcam-obs
    ]) ++ [
      obs-aitum-vertical
    ];
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      leonardssh.vscord
    ];
    profiles.default.userSettings = {
      "update.mode" = "none";
      "telemetry.telemetryLevel" = "off";
      "window.titleBarStyle" = "custom";

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

  programs.kate = {
    enable = true;
    plugins = [
      (pkgs.callPackage ../../pkgs/kate-discord-rpc.nix { })
    ];
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "AureliusGemini";
      user.email = "93374856+AureliusGemini@users.noreply.github.com";
    };
  };

  home.stateVersion = "26.05";
}
