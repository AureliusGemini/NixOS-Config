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

    protonup-qt
    protontricks
    lutris
    heroic
    faugus-launcher

    opencode-desktop

    # Kate + Discord RPC plugin
    kdePackages.kate
    (pkgs.stdenv.mkDerivation {
      pname = "kate-discord-rpc";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "leia-uwu";
        repo = "kate-discord-rpc";
        rev = "refs/heads/master";
        hash = "sha256-TWMYy6oeFJZ1WTS9tNQLk9RcRBwkvVrZy9kVU2Kr90s=";
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
        pkgs.rapidjson
      ];
    })
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "AureliusGemini";
      user.email = "93374856+AureliusGemini@users.noreply.github.com";
    };
  };

  home.stateVersion = "26.05";
}
