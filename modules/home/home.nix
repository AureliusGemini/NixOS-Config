{ config, pkgs, ... }:

{
  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  home.sessionVariables = {
    # This forces all launchers to look at Steam's custom tool folder
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
  };

  home.packages = with pkgs; [
    (discord.override { withVencord = true; })
    kdePackages.plasma-browser-integration

    protonup-qt
    protontricks
    lutris
    heroic
    faugus-launcher

    #     modrinth-app

    opencode-desktop

    # Kate + Discord RPC plugin
    kdePackages.kate
    (pkgs.stdenv.mkDerivation {
      pname = "kate-discord-rpc";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "leia-uwu";
        repo = "kate-discord-rpc";
        rev = "a597c4bd3f45811c7fa15f50f4fa6e8bd2aa9500"; # <--- Exact commit hash instead of "main"
        hash = "sha256-R41J5Y8N5S4S/21hO8S+yO9A7L4L8O0X1M0M0M0M0M0="; # Nix will mismatch this and output the real SHA256
        fetchSubmodules = true;
      };
      nativeBuildInputs = [
        pkgs.cmake
        pkgs.kdePackages.extra-cmake-modules
        pkgs.kdePackages.wrapQtAppsHook
      ];
      buildInputs = with pkgs.kdePackages; [
        ktexteditor
        kcoreaddons
        kconfig
        ki18n
        qtbase
      ];
    })
    nixd
    nixfmt
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide # <--- Replace bbenoist.nix with this
      ms-vscode.cpptools
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "AureliusGemini";
      user.email = "aureliusgemini@gmail.com";
    };
  };

  home.stateVersion = "26.05";
}
