{ pkgs, ... }:

{
  home.username = "aurelius";
  home.homeDirectory = "/home/aurelius";

  home.packages = with pkgs; [
    nixd
    nixfmt
    bash-language-server
    shellcheck
    clang-tools
    pyright
    typescript-language-server
    dart
    omnisharp-roslyn
  ];

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
