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

    # Tailscale system tray GUI for KDE Plasma
    tailscale-systray

    protonup-qt
    protontricks
    lutris
    heroic
    faugus-launcher

    opencode-desktop

    # Language Servers & Linters
    nixd                     # Nix LSP
    nixfmt                   # Nix formatter (replaces deprecated nixfmt-rfc-style)
    bash-language-server     # Bash LSP
    shellcheck               # Bash linter
    clang-tools              # C/C++ (clangd)
    pyright                  # Python LSP
    typescript-language-server # JS/TS LSP
    dart                     # Dart/Flutter LSP
    omnisharp-roslyn         # C# (.NET / Unity)
  ];

  programs.obs-studio = {
    enable = true;
    plugins = (with pkgs.obs-studio-plugins; [
      obs-aitum-multistream
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
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
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
      user = {
        name = "AureliusGemini";
        email = "93374856+AureliusGemini@users.noreply.github.com";
      };
    };
  };

  home.stateVersion = "26.05";
}
