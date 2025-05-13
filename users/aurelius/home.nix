# Home Manager configuration for aurelius
{ config, lib, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # Install packages
  home.packages = with pkgs; [
    # Development
    vscode
    
    # Utilities
    htop
    ripgrep
    fd
    
    # Applications
    firefox
  ];

  # Configure Git
  programs.git = {
    enable = true;
    userName = "Elvin Aurelius Yamin";
    userEmail = "aureliusgemini@users.noreply.github.com";
    signing = {
      key = null;
      signByDefault = false;
    };
    extraConfig = {
      github.user = "AureliusGemini";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";
}
