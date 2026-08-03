{ config, pkgs, ... }:

{
  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  home.packages = with pkgs; [
    (discord.override { withVencord = true; })
    kdePackages.plasma-browser-integration

    protonup-qt
    protontricks
    lutris
    heroic
    faugus-launcher

    opencode-desktop

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
      bbenoist.nix
      ms-vscode.cpptools
    ];
    profiles.default.userSettings = {
      "update.mode" = "none";
      "telemetry.telemetryLevel" = "off";
      "window.titleBarStyle" = "custom";
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
